resource "azurerm_public_ip" "main" {
  name                = "pip-bastion-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = var.sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
