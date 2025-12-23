data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                       = "kv-${var.workload}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true

  # Further controlled by network_acls below
  public_network_access_enabled = true

  network_acls {
    default_action = "Deny"
    ip_rules       = var.allowed_ip_addresses
    bypass         = "AzureServices"
  }
}

resource "azurerm_role_assignment" "current_key_vault_administrator" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "win11_azureuser_password" {
  name         = "win11-azureuser-password"
  value        = var.win11_azureuser_password
  key_vault_id = azurerm_key_vault.default.id

  depends_on = [azurerm_role_assignment.current_key_vault_administrator]
}
