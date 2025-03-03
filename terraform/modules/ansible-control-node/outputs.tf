output "private_ip" {
  value = azurerm_linux_virtual_machine.this.private_ip_address
}

output "awx_admin_password" {
  value     = fileexists("awx_password.txt") ? file("awx_password.txt") : "Not available yet"
}

output "awx_port" {
  value = fileexists("awx_port.txt") ? file("awx_port.txt") : "Not available yet"
}
