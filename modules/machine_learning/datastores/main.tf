data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

locals {
  tenant_id       = data.azuread_client_config.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}

### Datastores ###
resource "azurerm_machine_learning_datastore_blobstorage" "customers" {
  name                 = "blobstorage_customers"
  workspace_id         = var.workspace_id
  storage_container_id = var.blob_storage_container_id
  account_key          = var.blob_storage_account_key
}

resource "azurerm_machine_learning_datastore_datalake_gen2" "contacts" {
  name         = "datalake_contacts"
  workspace_id = var.workspace_id
  # storage_container_id = var.data_lake_storage_filesystem_id
  storage_container_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.data_lake_storage_account_name}/blobServices/default/containers/${var.data_lake_storage_filesystem_name}"

  tenant_id     = local.tenant_id
  client_id     = var.application_registration_client_id
  client_secret = var.application_registration_client_secret
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
