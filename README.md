# Overview

Ansible lab environment - Sets up an VM in Azure with Ansible and AWX.

# Setup and deployment

1. Configure TailScale -
  - First need to provision a TailScale Auth Key for the Subnet Router. Once you have a valid Auth Key set the `tailscale_subnet_router_auth_key` secret in `secrets.auto.tfvars` with the appropriate value.
  - Add a TailScale DNS Nameserver for the private IP address of the Inbound Endpoint of the Azure Private DNS Resolver (e.g. 10.0.0.4) with a domain of the specified `private_dns` setting (under `terraform.tfvars`).
2. Build the TailScale Subnet Router and the Ansible Control Node machine images with packer
  - Navigate to `./packer/tailscale-subnet-router` and run `packer build -force .`.
  - Navigate to `./packer/ansible-control-node` and run `packer build -force .`.
3. Deploy the solution using `terraform plan --out=plan.tfplan` followed by `terraform apply "plan.tfplan"`.
4. Once the terraform script is complete, navigate to the  `awx_location` (terraform output variable) to get to the AWX portal.
5. Login to AWX as admin. The password will be the value of the `awx_admin_password`  terraform output variable.
6. Change the admin password to something easier to remember.

# Debugging the Ansible control node custom_data init script:

The ansible control node takes about 15 minutes to provision as it takes quite a while for the AWX operator to get up and running. To debug where things are up to, you can SSH to the Ansible Control Node using `ssh {username}@{private-ip-of-ansible-control-node} -i {path-to-ssh-private-key}` and view the logs associated to the custom_data init script using `sudo less /var/log/cloud-init-output.log`.

# Destroy

`terraform destroy`
