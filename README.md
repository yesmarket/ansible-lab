# Overview

Ansible lab environment

# Setup and deployment

1. First need to provision a TailScale Auth Key for the Subnet Router. There *might* already be one that you can re-use, but previous ones might have been provisioned as non-reusable and they do expire. Once you have a valid Auth Key set the `tailscale_subnet_router_auth_key` secret in `secrets.auto.tfvars` with the appropriate value.
2. Deploy the solution using `terraform plan --out=plan.tfplan` and `terraform apply "plan.tfplan"`.
3. You *might* need to go into TailScale and view the Machines to ensure the Subnet Router is connected and the Advertised Routes (subnet CIDRs) are all approved.
4. Add a TailScale DNS Nameserver for the private IP address of the Inbound Endpoint of the Azure Private DNS Resolver (e.g. 10.0.0.4) with a domain of the specified `private_dns` setting (under `terraform.tfvars`).
5. SSH to the Ansible Control Node using `ssh {username}@{private-ip-of-ansible-control-node} -i {path-to-ssh-private-key}`

# Destroy

`terraform destroy`
