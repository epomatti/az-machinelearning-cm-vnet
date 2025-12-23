data "azuread_client_config" "current" {}

locals {
  owners = [data.azuread_client_config.current.object_id, var.administrator_user_object_id]
}

resource "azuread_application" "datastores" {
  display_name = "datastores-${var.workload}"
  owners       = local.owners
}

resource "azuread_service_principal" "datastores" {
  client_id = azuread_application.datastores.client_id
  owners    = local.owners
}

resource "azuread_application_password" "datastores" {
  application_id = azuread_application.datastores.id
}
