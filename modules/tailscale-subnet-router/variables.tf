variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the subnet-router (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the subnet-router."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to delpoy the subnet-router."
}

variable "username" {
  type        = string
  description = "The SSH username for accessing the subnet-router."
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing the subnet-router."
}

variable "auth_key" {
  type        = string
  description = "The auth key to authenticate the subnet-router without an interactive login."
  sensitive   = true
}

variable "advertised_routes" {
  type        = string
  description = "The IP ranges/addresses that will go to the subnet-router."
}

variable "vm_size" {
  type        = string
  description = "The size of the subnet-router VM."
  default     = "Standard_F2"
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

variable "source_image_id" {
  type        = string
  description = "The tailscale subnet-router custom image id"
  default     = "/subscriptions/46934691-fbae-44fe-abb8-900c33ca8095/resourceGroups/images/providers/Microsoft.Compute/images/tailscale-subnet-router"
}
