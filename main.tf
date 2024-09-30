# RGs

resource "azurerm_resource_group" "this" {
  name     = "${local.naming_prefix}-rg"
  location = var.location
}

# VNETs

resource "azurerm_virtual_network" "this" {
  name                = "${local.naming_prefix}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.vnet_cidr]
}

# subnets

resource "azurerm_subnet" "dnspr" {
  name                 = "${local.naming_prefix}-dnspr-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 0)]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "private" {
  name                 = "${local.naming_prefix}-private-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 1)]
}

# DNS

resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${local.naming_prefix}-dns-zone-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_resolver" "this" {
  name                = "${local.naming_prefix}-dnspr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_network_id  = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = "${local.naming_prefix}-in"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dnspr.id
  }
}

# tailscale subnet-router

module "tailscale_subnet_router" {
  source              = "./modules/tailscale-subnet-router"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id
  username            = var.username
  ssh_public_key      = var.ssh_public_key
  auth_key            = var.tailscale_subnet_router_auth_key
  advertised_routes   = var.vnet_cidr
}

# Ansible control node

module "ansible_control_node" {
  source                 = "./modules/ansible-control-node"
  naming_prefix          = local.naming_prefix
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  subnet_id              = azurerm_subnet.private.id
  username               = var.username
  ssh_public_key         = var.ssh_public_key
  ssh_private_key_base64 = var.ssh_private_key_base64
  ssh_passphrase         = var.ssh_passphrase
}

# Linux VM inventory

module "linux_vm" {
  for_each            = toset(var.inventory)
  source              = "./modules/linux-vm"
  naming_prefix       = local.naming_prefix
  unique_identifier   = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id
  username            = var.username
  ssh_public_key      = var.ssh_public_key
  public              = false
  private_dns_zone    = azurerm_private_dns_zone.this.name
}
