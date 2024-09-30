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
    ssh_public_key         = var.ssh_public_key
    ssh_private_key_base64 = var.ssh_private_key_base64
    ssh_passphrase         = var.ssh_passphrase
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

  #source_image_reference {
  #  publisher = var.source_image_publisher
  #  offer     = var.source_image_offer
  #  sku       = var.source_image_sku
  #  version   = var.source_image_version
  #}

  provisioner "remote-exec" {
    inline = [
      "base64 -d <<< ${var.ssh_private_key_base64} >> ~/.ssh/id_rsa",
      "echo ${var.ssh_public_key} >> ~/.ssh/id_rsa.pub",
      "sudo chmod 600 ~/.ssh/id_rsa",
      "sudo chmod 600 ~/.ssh/id_rsa.pub",
      "eval $(ssh-agent -s)",
      "echo \"echo ${var.ssh_passphrase}\" >> ./passphrase",
      "sudo chmod 700 ./passphrase",
      "DISPLAY=1 SSH_ASKPASS=\"./passphrase\" ssh-add ~/.ssh/id_rsa < /dev/null",
      "rm ./passphrase",
    ]

    connection {
      type        = "ssh"
      host        = self.private_ip_address
      user        = var.username
      private_key = base64decode(var.ssh_private_key_base64)
    }
  }
}
