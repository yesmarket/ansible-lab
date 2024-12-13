resource "azurerm_network_interface" "this" {
  name                = "${local.ansible_control_node_vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${local.ansible_control_node_vm_name}-cfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = local.ansible_control_node_vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = true

  custom_data = base64encode(templatefile("${path.module}/templates/bootstrap-script.tpl", {
    username               = var.username
    password               = var.password
    ssh_public_key         = var.ssh_public_key
    ssh_private_key_base64 = var.ssh_private_key_base64
    ssh_passphrase         = var.ssh_passphrase
    email                  = var.email
    name                   = var.name
  }))

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.ansible_control_node_vm_name}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_id = var.source_image_id
}
