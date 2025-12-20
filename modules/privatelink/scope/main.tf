# https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/privatelinkscopes?pivots=deployment-language-terraform
# Reference: https://github.com/hashicorp/terraform-provider-azurerm/issues/19370
resource "azurerm_monitor_private_link_scope" "default" {
  name                = "ampls-${var.workload}"
  resource_group_name = var.resource_group_name

  # Must use "Open" mode following the documentation for Machine Learning:
  # https://learn.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet?view=azureml-api-2&tabs=required%2Cpe%2Ccli#azure-monitor
  ingestion_access_mode = "Open"
  query_access_mode     = "Open"
}

resource "azurerm_monitor_private_link_scoped_service" "log_analytics_workspace" {
  name                = "amplsmonitor-${var.workload}"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.default.name
  linked_resource_id  = var.log_analytics_workspace_id
}

resource "azurerm_monitor_private_link_scoped_service" "application_insights" {
  name                = "amplsservice-${var.workload}"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.default.name
  linked_resource_id  = var.application_insights_id
}
