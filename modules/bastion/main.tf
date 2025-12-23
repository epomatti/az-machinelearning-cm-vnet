resource "azurerm_public_ip" "main" {
  count               = var.sku == "Developer" ? 0 : 1
  name                = "pip-${var.workload}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # zones               = var.zones
  sku                 = var.sku

  virtual_network_id = var.sku == "Developer" ? var.virtual_network_id : null

  dynamic "ip_configuration" {
    for_each = var.sku == "Developer" ? [] : [""]
    content {
      name                 = "configuration"
      subnet_id            = var.subnet
      public_ip_address_id = azurerm_public_ip.main[0].id
    }
  }
}
