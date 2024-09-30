resource "azurerm_public_ip" "this" {
  count               = var.public ? 1 : 0
  name                = "${local.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "this" {
  name                = "${local.vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${local.vm_name}-cfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public ? azurerm_public_ip.this.0.id : null
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = local.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.username

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
}

resource "azurerm_private_dns_a_record" "this" {
  name                = var.unique_identifier
  zone_name           = var.private_dns_zone
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.this.private_ip_address]
}
