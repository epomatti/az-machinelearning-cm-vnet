# variable "datastores_service_principal_object_id" {
#   type = string
# }

# variable "datalake_id" {
#   type = string
# }

variable "workspace_id" {
  type = string
}

### Blob Storage ###
variable "blob_storage_container_id" {
  type = string
}

variable "blob_storage_account_key" {
  type      = string
  sensitive = true
}

### Data Lake ###
variable "resource_group_name" {
  type = string
}

variable "data_lake_storage_account_name" {
  type = string
}

variable "data_lake_storage_filesystem_id" {
  type = string
}

variable "data_lake_storage_filesystem_name" {
  type = string
}

variable "application_registration_client_id" {
  type = string
}

variable "application_registration_client_secret" {
  type      = string
  sensitive = true
}
