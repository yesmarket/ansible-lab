output "tailscale_subnet_router_public_ip" {
  value = module.tailscale_subnet_router.public_ip
}

output "private_dns_resolver_private_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address
}

output "admin_username" {
  value = var.admin_username
}

output "ansible_control_node_private_ip" {
  value = module.ansible_control_node.private_ip
}

output "ansible_control_node_fqdn" {
  value = "ansible.${var.private_dns}"
}

output "awx_location" {
  value = "http://ansible.${var.private_dns}"
}

output "awx_admin_password" {
  value = module.ansible_control_node.awx_admin_password
}
