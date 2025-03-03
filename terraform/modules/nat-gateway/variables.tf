variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."	
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the NAT gateway (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the NAT gateway."
}

variable "subnet_id" {
  type        = string
  description = "The subnet to associate with the NAT gateway."
}
