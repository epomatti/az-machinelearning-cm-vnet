output "network_resource_group_name" {
  value = azurerm_resource_group.network.name
}

output "virtual_machines_resource_group_name" {
  value = azurerm_resource_group.virtual_machines.name
}

output "machine_learning_resource_group_name" {
  value = azurerm_resource_group.machine_learning.name
}

output "private_link_resource_group_name" {
  value = azurerm_resource_group.private_link.name
}

output "monitor_resource_group_name" {
  value = azurerm_resource_group.monitor.name
}

output "ampls_resource_group_name" {
  value = azurerm_resource_group.ampls.name
}

output "resouce_groups_ids" {
  value = [
    azurerm_resource_group.network.id,
    azurerm_resource_group.virtual_machines.id,
    azurerm_resource_group.machine_learning.id,
    azurerm_resource_group.private_link.id,
    azurerm_resource_group.monitor.id,
    azurerm_resource_group.ampls.id,
  ]
}
