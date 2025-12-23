# Documentation:https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg

resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.workload}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.default.id

  depends_on = [
    # Inbound
    azurerm_network_security_rule.AllowHttpsInbound,
    azurerm_network_security_rule.AllowGatewayManagerInbound,
    azurerm_network_security_rule.AllowAzureLoadBalancerInbound,
    azurerm_network_security_rule.AllowBastionHostCommunication,

    # Outbound
    azurerm_network_security_rule.AllowSshRdpOutbound,
    azurerm_network_security_rule.AllowAzureCloudOutbound,
    azurerm_network_security_rule.AllowBastionCommunication,
    azurerm_network_security_rule.AllowHttpOutbound,
  ]
}

### Inbound ###
resource "azurerm_network_security_rule" "AllowHttpsInbound" {
  name                        = "AllowHttpsInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "Internet"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowGatewayManagerInbound" {
  name                        = "AllowGatewayManagerInbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "GatewayManager"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowAzureLoadBalancerInbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowBastionHostCommunication" {
  name                        = "AllowBastionHostCommunication"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["8080", "5701"]
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

### Outbound ###
resource "azurerm_network_security_rule" "AllowSshRdpOutbound" {
  name                        = "AllowSshRdpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["22", "3389"]
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowAzureCloudOutbound" {
  name                        = "AllowAzureCloudOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "AzureCloud"
  destination_port_ranges     = ["443"]
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowBastionCommunication" {
  name                        = "AllowBastionCommunication"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["8080", "5701"]
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "AllowHttpOutbound" {
  name                        = "AllowHttpOutbound"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "Internet"
  destination_port_ranges     = ["80"]
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}
