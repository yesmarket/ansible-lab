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

resource "null_resource" "wait_for_cloud_init" {
  triggers = {
    vm_id            = azurerm_linux_virtual_machine.this.id
    custom_data_hash = md5(azurerm_linux_virtual_machine.this.custom_data)
  }

  depends_on = [azurerm_linux_virtual_machine.this]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = base64decode(var.ssh_private_key_base64)
      host        = azurerm_linux_virtual_machine.this.private_ip_address
      timeout     = "30m"
    }

    inline = [
      "echo 'Waiting for cloud-init to finish...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done",
      "echo 'Cloud-init complete!'"
    ]
  }
}

resource "null_resource" "get_awx_admin_password" {
  triggers = {
    vm_id            = azurerm_linux_virtual_machine.this.id
    custom_data_hash = md5(azurerm_linux_virtual_machine.this.custom_data)
  }

  depends_on = [null_resource.wait_for_cloud_init]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = base64decode(var.ssh_private_key_base64)
      host        = azurerm_linux_virtual_machine.this.private_ip_address
    }

    inline = [
      "echo 'Fetching AWX admin password...'",
      "export AWX_PASSWORD=$(kubectl get secret awx-ubuntu-admin-password -n ansible-awx -o jsonpath='{.data.password}' | base64 --decode)",
      "echo \"AWX admin password: $AWX_PASSWORD\""
    ]
  }
}
