output "storage_account_id" {
  value = azurerm_storage_account.default.id
}

output "storage_account_name" {
  value = azurerm_storage_account.default.name
}

output "customers_storage_container_id" {
  value = azurerm_storage_container.customers.id
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.default.primary_access_key
}
