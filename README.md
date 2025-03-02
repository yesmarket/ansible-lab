# Overview

Ansible lab environment

# Setup and deployment

1. First need to provision a TailScale Auth Key for the Subnet Router. There *might* already be one that you can re-use, but previous ones might have been provisioned as non-reusable and they do expire. Once you have a valid Auth Key set the `tailscale_subnet_router_auth_key` secret in `secrets.auto.tfvars` with the appropriate value.
2. Deploy the solution using `terraform plan --out=plan.tfplan` and `terraform apply "plan.tfplan"`. You might need to wait a few minutes for the custom_data init script to complete (as creating the AWX operator can take a bit of time). You can check the logs associated to the custom_data init script to see where things are up to.
3. You *might* need to go into TailScale and view the Machines to ensure the Subnet Router is connected and the Advertised Routes (subnet CIDRs) are all approved.
4. Add a TailScale DNS Nameserver for the private IP address of the Inbound Endpoint of the Azure Private DNS Resolver (e.g. 10.0.0.4) with a domain of the specified `private_dns` setting (under `terraform.tfvars`).
5. SSH to the Ansible Control Node using `ssh {username}@{private-ip-of-ansible-control-node} -i {path-to-ssh-private-key}`.
6. Open a browser to the AWX portal at `http://<private_dns>:<port>`. You can get the `private_dns` from terraform.tfvars and the `port` by SSHing into the Ansible control node and running the script to get the AWX port number.
7. SSH to the Ansible control node and run the script to get the admin user password.
8. Change the admin user password to something easier to remember.

# Ansible control node scripts:

1. View the logs associated to the custom_data initialization script: `sudo less /var/log/cloud-init-output.log`
2. Get the AWX port number: `minikube service awx-ubuntu-service --url -n ansible-awx | cut -d ':' -f 3`
3. Get the AWX admin user password: `kubectl get secret awx-ubuntu-admin-password -n ansible-awx -o jsonpath="{.data.password}" | base64 --decode`

# Destroy

`terraform destroy`
