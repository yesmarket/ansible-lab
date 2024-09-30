output "tailscale_subnet_router_public_ip" {
  value = module.tailscale_subnet_router.public_ip
}

output "private_dns_resolver_private_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address
}
