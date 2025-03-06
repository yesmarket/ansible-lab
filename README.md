# Overview

Sets up an Ansible lab environment in Azure using Terraform (and Packer)

The lab deploys the following components:
- A virtual network in Azure with a NAT gateway for access to the Internet.
- An Ansible control node that also has Ansible AWX (deployed to minikube on the VM)
- A TailScale subnet router for access to the Ansible network
- A configurable number of Linux VM managed nodes - the default is 2 (test1 and test2 - see `inventory` variable in `terraform.tfvars`)

# Setup and deployment

1. Configure TailScale -
    - First need to provision a TailScale Auth Key for the Subnet Router. Once you have a valid Auth Key set the `tailscale_subnet_router_auth_key` secret in `secrets.auto.tfvars` with the appropriate value.
    - Add a TailScale DNS Nameserver for the private IP address of the Inbound Endpoint of the Azure Private DNS Resolver (e.g. 10.0.0.4) with a domain of the specified `private_dns` setting (under `terraform.tfvars`).
2. Build the TailScale Subnet Router and the Ansible Control Node machine images using packer
    - Navigate to `./packer/tailscale-subnet-router` and run `packer build -force .`.
    - Navigate to `./packer/ansible-control-node` and run `packer build -force .`.
3. Deploy the solution using `terraform plan --out=plan.tfplan` followed by `terraform apply "plan.tfplan"`.

That's it!

# Accessing the Ansible control node

Assuming you have TailScale running locally, you should be able to SSH to the Ansible control node using `ssh {admin_username}@{ansible_control_node_private_ip} -i {path-to-ssh-private-key}` (or `ssh {admin_username}@{ansible_control_node_fqdn} -i {path-to-ssh-private-key}`)

Note: `admin_username`, `ansible_control_node_private_ip`, and `ansible_control_node_fqdn` are all outputs from Terraform.

# Accessing the Ansible AWX web portal

There's a Terraform output variable `awx_location`. Once the Terraform script is complete, open a web browser and navigate to the specified AWX location.

You can login as the admin user with a username of `admin`. There were some challenges getting the AWX admin password to display as a Terraform output variable, so I just echo it out as part of the remote-exec provisioner in the `get_awx_admin_password` null resource (which runs after the ansible-control-node VM is provisioned and the custom_data init script has completed). It will appear near the end of the Terraform logs.

Once you login for the first time, it's probably a good idea to change the AWX admin password.

# Debugging the Ansible control node custom_data init script:

The ansible control node takes about 15 minutes to provision as it takes quite a while for the AWX operator to get up and running. To debug where things are up to, you can SSH to the Ansible Control Node and view the logs associated to the custom_data init script using `sudo less /var/log/cloud-init-output.log`.

# Destroy

`terraform destroy`
