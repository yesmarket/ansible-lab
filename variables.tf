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

variable "location" {
  type        = string
  description = "Azure subscription ID."
  default     = "Australia East"
}

variable "admin_username" {
  type        = string
  description = "The SSH/RDP username for accessing VMs."
  default     = "ryanbartsch"
}

variable "admin_password" {
  type        = string
  description = "The RDP password for accessing VMs."
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing VMs."
}

variable "ssh_private_key_base64" {
  type        = string
  description = "The base64 value of the SSH private key to access VMs."
  sensitive   = true
}

variable "awx_admin_password" {
  type        = string
  description = "The admin password to log into AWX."
  sensitive   = true
}

variable "tailscale_subnet_router_auth_key" {
  type        = string
  description = "Used to authenticate subnet-router VMs without an interactive login."
  sensitive   = true
}

variable "tailscale_subnet_routers" {
  type        = list(any)
  description = "A list of subnet-routers to deploy. Multiple items represents a HA subnet-router configuraiton."
  default     = ["primary"]
}

variable "private_dns" {
  type        = string
  description = "The name of the private DNS zone for the VMs."
}

variable "inventory" {
  type        = list(any)
  description = "A list of linux VMs to deploy."
  default     = ["test"]
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the network VNET."
  default     = "10.0.0.0/24"
}

variable "git_name" {
  type        = string
  description = "The user name for git config"
}

variable "git_email" {
  type        = string
  description = "The user email for git config"
}



