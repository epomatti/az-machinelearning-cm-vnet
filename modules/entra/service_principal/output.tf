output "app_registration_client_id" {
  value = azuread_application.datastores.client_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.datastores.object_id
}

output "service_principal_id" {
  value = azuread_service_principal.datastores.id
}

output "client_id" {
  value = azuread_application.datastores.client_id
}

output "client_secret" {
  value     = azuread_application_password.datastores.value
  sensitive = true
}
