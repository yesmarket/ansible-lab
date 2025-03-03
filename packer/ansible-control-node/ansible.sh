#!/bin/bash

#####################################
# install Ansible
# Note: we'll also deploy Ansible AWX (to minikube) on the VM,
# but it's nice to have the Ansible CLI on the base image as well
#####################################
sudo add-apt-repository universe
sudo apt-get -y upgrade
sudo apt-get -y update
sudo apt -y install python3-pip keychain
sudo pip3 install ansible --no-warn-script-location


#####################################
# install VSCode - might want to work on Ansible project using VSCode via MobaXterm
#####################################
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code
code --install-extension redhat.ansible


#####################################
# install docker
#####################################
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER


#####################################
# install minicube
#####################################
sudo apt update
sudo apt install -y curl wget apt-transport-https
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


#####################################
# install kubectl
#####################################
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/


#####################################
# install other stuff
#####################################
sudo apt install git make -y
sudo python3 -m pip install argcomplete
