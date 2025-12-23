resource "azurerm_resource_group" "network" {
  name     = "rg-${var.workload}-network-${var.affix}"
  location = var.location
}

resource "azurerm_resource_group" "virtual_machines" {
  name     = "rg-${var.workload}-virtual-machines-${var.affix}"
  location = var.location
}

resource "azurerm_resource_group" "machine_learning" {
  name     = "rg-${var.workload}-machine-learning-${var.affix}"
  location = var.location
}

resource "azurerm_resource_group" "private_link" {
  name     = "rg-${var.workload}-privatelink-${var.affix}"
  location = var.location
}
