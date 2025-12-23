### Datastores ###
resource "azurerm_machine_learning_datastore_blobstorage" "customers" {
  name                 = "blobstorage_customers"
  workspace_id         = var.workspace_id
  storage_container_id = var.blob_storage_container_id
  account_key          = var.blob_storage_account_key
}

### Permissions ###
# resource "azurerm_role_assignment" "datalake_owner" {
#   scope                = var.datalake_id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = var.datastores_service_principal_object_id
# }

# resource "azurerm_role_assignment" "datalake_contributor" {
#   scope                = var.datalake_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.datastores_service_principal_object_id
# }
