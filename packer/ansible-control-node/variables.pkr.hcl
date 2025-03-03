variable "tenant_id" {
  type        = string
  description = "AAD tennant ID."
}

variable "client_id" {
  type        = string
  description = "Azure service principal client ID."
}

variable "client_secret" {
  type        = string
  description = "Azure service principal client secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "image_name" {
  type        = string
  description = "The name of the managed image."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain managed image."
}

variable "location" {
  type        = string
  description = "The location of the image."
}

variable "source_image_publisher" {
  type        = string
  description = "The source image publisher"
}

variable "source_image_offer" {
  type        = string
  description = "The source image offer"
}

variable "source_image_sku" {
  type        = string
  description = "The source image sku"
}

variable "source_image_version" {
  type        = string
  description = "The source image version"
}

variable "vm_size" {
  type        = string
  description = "The size of the VM."
}
