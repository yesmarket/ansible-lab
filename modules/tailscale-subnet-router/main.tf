resource "azurerm_public_ip" "this" {
  name                = "${local.subnet_router_vm_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "this" {
  name                = "${local.subnet_router_vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${local.subnet_router_vm_name}-cfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = local.subnet_router_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.username

  custom_data = base64encode(templatefile("${path.module}/templates/bootstrap-script.tpl", {
    auth_key          = var.auth_key
    advertised_routes = var.advertised_routes
  }))

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.subnet_router_vm_name}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_id = var.source_image_id
}
