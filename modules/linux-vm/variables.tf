variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."
}

variable "unique_identifier" {
  type        = string
  description = "The identifier for the VM."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the VM (and related resources)."
}

variable "private_dns_zone" {
  type        = string
  description = "The private DNS zone for the VM."
}

variable "location" {
  type        = string
  description = "The location of the VM."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to deploy the VM."
}

variable "username" {
  type        = string
  description = "The SSH username for accessing the VM."
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing the VM."
}

variable "vm_size" {
  type        = string
  description = "The size of the VM."
  default     = "Standard_A1_v2"
}

variable "disk_caching" {
  type        = string
  description = "The VM disk caching."
  default     = "ReadWrite"
}

variable "disk_storage_account_type" {
  type        = string
  description = "The VM disk storage account type."
  default     = "Standard_LRS"
}

variable "source_image_publisher" {
  type        = string
  description = "The source image publisher"
  default     = "Canonical"
}

variable "source_image_offer" {
  type        = string
  description = "The source image offer"
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  type        = string
  description = "The source image sku"
  default     = "22_04-lts"
}

variable "source_image_version" {
  type        = string
  description = "The source image version"
  default     = "latest"
}

variable "public" {
  type        = bool
  description = "Defines whether the VM gets a public IP or not"
  default     = false
}
