output "private_ip" {
  value = azurerm_linux_virtual_machine.this.private_ip_address
}

output "awx_admin_password" {
  value = "see logs"
}

