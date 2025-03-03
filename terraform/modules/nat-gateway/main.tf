# NAT Gateway
resource "azurerm_nat_gateway" "this" {
  name                = local.nat_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Public IP address for NAT gateway
resource "azurerm_public_ip" "this" {
  name                = "${local.nat_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Associate NAT Gateway with Public IP
resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this.id
}

# Associate NAT Gateway with Subnet
resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
