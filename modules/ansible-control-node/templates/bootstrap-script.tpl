#!/bin/bash

#####################################
# ssh config
#####################################

# Set up SSH directory
sudo -u ${admin_username} mkdir -p /home/${admin_username}/.ssh
sudo chmod 700 /home/${admin_username}/.ssh

# Store SSH keys securely
echo ${ssh_public_key} | sudo tee /home/${admin_username}/.ssh/id_rsa.pub > /dev/null
echo ${ssh_private_key_base64} | base64 --decode | sudo tee /home/${admin_username}/.ssh/id_rsa > /dev/null

# Set correct permissions
sudo chmod 600 /home/${admin_username}/.ssh/id_rsa
sudo chmod 644 /home/${admin_username}/.ssh/id_rsa.pub
sudo chown -R ${admin_username}:${admin_username} /home/${admin_username}/.ssh

# Automatically accept SSH host keys for managed nodes
for NODE in ${inventory}; do
    echo "Adding SSH key for $NODE"
    sudo -u ${admin_username} ssh-keyscan -H "$NODE" >> /home/${admin_username}/.ssh/known_hosts
done

# Ensure SSH agent starts with the key loaded
echo "eval \$(ssh-agent -s)" | sudo tee -a /home/${admin_username}/.bashrc > /dev/null
echo "ssh-add /home/${admin_username}/.ssh/id_rsa" | sudo tee -a /home/${admin_username}/.bashrc > /dev/null


#####################################
# configure admin password
#####################################

echo "${admin_username}:${admin_password}" | sudo chpasswd
echo "${admin_username} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${admin_username} > /dev/null
sudo chmod 0440 /etc/sudoers.d/${admin_username}


#####################################
# configure Ansible arg completion
#####################################

# Enable Ansible completion explicitly
sudo activate-global-python-argcomplete

# Ensure Ansible completion is sourced
echo 'eval "$(register-python-argcomplete ansible)"' | sudo tee -a /etc/bash.bashrc > /dev/null
echo 'eval "$(register-python-argcomplete ansible-playbook)"' | sudo tee -a /etc/bash.bashrc > /dev/null

# Reload the shell configuration
source /etc/bash.bashrc


######################################
# configure docker
######################################

# Add user admin user to the docker group
sudo usermod -aG docker ${admin_username}

# Apply the new group membership immediately
sudo su - ${admin_username} -c "docker --version && docker run hello-world"


######################################
# start and configure minikube
######################################

# Start Minikube with desired settings
sudo -u ${admin_username} sg docker -c "minikube start --driver=docker --cpus=${minikube_cpus} --memory=${minikube_memory} --addons=ingress"

# Ensure correct permissions for Minikube directories
sudo chown -R ${admin_username} "/home/${admin_username}/.minikube"
sudo chmod -R u+wrx "/home/${admin_username}/.minikube"


#####################################
# git config
#####################################
sudo -u ${admin_username} bash -c "
  export HOME=/home/${admin_username}
  git config --global user.email '${git_email}'
  git config --global user.name '${git_name}'
"


#####################################
# deploy AWX to minikube
#####################################

sudo -u ${admin_username} bash -c "
  export HOME=/home/${admin_username}
  cd /home/${admin_username}

  # Clone the AWX Operator repo
  git clone https://github.com/ansible/awx-operator.git
  cd awx-operator

  # Checkout the required version
  git checkout 2.19.0

  # Set up the namespace and deploy AWX
  export NAMESPACE=ansible-awx
  make deploy

  # Modify the AWX deployment file
  cp awx-demo.yml awx-ubuntu.yml
  sed -i 's/awx-demo/awx-ubuntu/g' awx-ubuntu.yml
"

# Ensure Minikube is running
sudo -u ${admin_username} bash -c "
  minikube status || minikube start --driver=docker --cpus=2 --memory=4000 --addons=ingress
  kubectl config use-context minikube
"

# Deploy AWX
sudo su - ${admin_username} -c "kubectl create -f /home/${admin_username}/awx-operator/awx-ubuntu.yml -n ansible-awx"


#####################################
# AWX port forwarding
#####################################

# Wait for AWX Task Pod
sudo -u ${admin_username} bash -c "
  echo 'Waiting for AWX task pod to appear...'
  while [ -z \"\$(kubectl get pods -n ansible-awx --no-headers -o custom-columns=\":metadata.name\" | grep '^awx-ubuntu-task')\" ]; do
    sleep 10
  done

  AWX_TASK_POD=\$(kubectl get pods -n ansible-awx --no-headers -o custom-columns=\":metadata.name\" | grep '^awx-ubuntu-task')

  echo \"AWX Task Pod: \$AWX_TASK_POD\"
  kubectl wait --for=condition=ready --timeout=600s pod/\$AWX_TASK_POD -n ansible-awx
"

# Wait for AWX service
sudo -u ${admin_username} bash -c "
  echo 'Waiting for AWX service to be created...'
  while ! kubectl get svc -n ansible-awx | grep -q 'awx-ubuntu-service'; do
    sleep 10
  done

  echo 'AWX service detected. Setting up port forwarding...'
  port=\$(minikube service awx-ubuntu-service --url -n ansible-awx | cut -d ':' -f 3)
  kubectl port-forward service/awx-ubuntu-service -n ansible-awx --address 0.0.0.0 \$port:80 &> /dev/null &
"
