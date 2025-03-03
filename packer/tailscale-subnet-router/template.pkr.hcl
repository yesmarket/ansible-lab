source "azure-arm" "this" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_publisher                   = var.source_image_publisher
  image_offer                       = var.source_image_offer
  image_sku                         = var.source_image_sku
  location                          = var.location
  managed_image_name                = var.image_name
  managed_image_resource_group_name = var.resource_group_name
  os_type                           = "Linux"
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  vm_size                           = var.vm_size
}

build {
  sources = ["source.azure-arm.this"]

  provisioner "shell" {
    script = "./tailscale.sh"
  }
}
