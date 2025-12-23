# variable "datastores_service_principal_object_id" {
#   type = string
# }

# variable "datalake_id" {
#   type = string
# }

variable "workspace_id" {
  type = string
}

variable "blob_storage_container_id" {
  type = string
}

variable "blob_storage_account_key" {
  type      = string
  sensitive = true
}
