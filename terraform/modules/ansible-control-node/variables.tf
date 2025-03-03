variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the ansible control node (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the ansible control node."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to delpoy the ansible control node."
}

variable "admin_username" {
  type        = string
  description = "The SSH/RDP username for accessing the ansible control node."
}

variable "admin_password" {
  type        = string
  description = "The RDP password for accessing the ansible control node."
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing the ansible control node."
}

variable "ssh_private_key_base64" {
  type        = string
  description = "The base64 value of the SSH private key to access VMs."
  sensitive   = true
}

variable "vm_size" {
  type        = string
  description = "The size of the ansible control node VM."
  default     = "Standard_F8"
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
  description = "The ansible control node custom image id"
  default     = "/subscriptions/46934691-fbae-44fe-abb8-900c33ca8095/resourceGroups/images/providers/Microsoft.Compute/images/ansible-control-node"
  #default     = "/subscriptions/1127d5c9-157b-48b2-9220-9795765f71ac/resourceGroups/images/providers/Microsoft.Compute/images/ansible-control-node"
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

variable "git_name" {
  type        = string
  description = "The user name for git config"
}

variable "git_email" {
  type        = string
  description = "The user email for git config"
}

variable "private_dns_zone" {
  type        = string
  description = "The private DNS zone for the VM."
}

variable "minikube_cpus" {
  type        = string
  description = "The number of CPUs to allocate to minikube."
  default     = 2
}

variable "minikube_memory" {
  type        = string
  description = "The amount of memory to allocate to minikube."
  default     = 4000
}

variable "inventory" {
  type        = list(any)
  description = "The list of Ansible managed nodes."
}
