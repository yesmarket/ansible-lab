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
  admin_username                  = var.admin_username
  disable_password_authentication = true

  custom_data = base64encode(templatefile("${path.module}/templates/bootstrap-script.tpl", {
    admin_username         = var.admin_username
    admin_password         = var.admin_password
    ssh_public_key         = var.ssh_public_key
    ssh_private_key_base64 = var.ssh_private_key_base64
    awx_admin_password     = var.awx_admin_password
    git_name               = var.git_name
    git_email              = var.git_email
    minikube_cpus          = var.minikube_cpus
    minikube_memory        = var.minikube_memory
    inventory              = join(" ", var.inventory)
  }))

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.ansible_control_node_vm_name}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_id = var.source_image_id
}

resource "azurerm_private_dns_a_record" "this" {
  name                = "ansible"
  zone_name           = var.private_dns_zone
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.this.private_ip_address]
}
