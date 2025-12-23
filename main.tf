terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.57.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.7.0"
    }
  }
}

resource "random_integer" "affix" {
  max = 999
  min = 000
}

locals {
  affix                = random_integer.affix.result
  allowed_ip_addresses = [var.allowed_ip_address]
}

module "resource_groups" {
  source   = "./modules/resource_groups"
  workload = var.workload
  location = var.location
  affix    = local.affix
}

module "network" {
  source                                  = "./modules/network"
  workload                                = var.workload
  resource_group_name                     = module.resource_groups.network_resource_group_name
  location                                = var.location
  allowed_ip_address                      = var.allowed_ip_address
  training_nsg_source_address_prefix      = var.vnet_training_nsg_source_address_prefix
  training_nsg_destination_address_prefix = var.vnet_training_nsg_destination_address_prefix
}

module "bastion" {
  count               = var.create_bastion_host ? 1 : 0
  source              = "./modules/bastion"
  workload            = var.workload
  location            = var.location
  resource_group_name = module.resource_groups.network_resource_group_name
  subnet              = module.network.bastion_subnet_id
  sku                 = var.bastion_host_sku
  virtual_network_id  = module.network.vnet_id

  depends_on = [module.network]
}

module "monitor" {
  source              = "./modules/monitor"
  workload            = var.workload
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location
}

module "blob_storage" {
  source              = "./modules/storage/blob"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location
  ip_network_rules    = local.allowed_ip_addresses
}

module "key_vault" {
  source               = "./modules/key_vault"
  workload             = "${var.workload}${local.affix}"
  resource_group_name  = module.resource_groups.machine_learning_resource_group_name
  location             = var.location
  allowed_ip_addresses = local.allowed_ip_addresses
}

module "container_registry" {
  source              = "./modules/container_registry"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location
  allowed_ip_address  = var.allowed_ip_address
}

module "entra_users" {
  source                  = "./modules/entra/users"
  tenant_domain           = var.entraid_tenant_domain
  data_scientist_username = var.entraid_data_scientist_username
  administrator_username  = var.entraid_administrator_username
  user_password           = var.default_password
}

module "entra_service_principal" {
  source                       = "./modules/entra/service_principal"
  workload                     = var.workload
  administrator_user_object_id = module.entra_users.administrator_user_object_id
}

module "data_lake_storage" {
  source              = "./modules/storage/lake"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location
  ip_network_rules    = local.allowed_ip_addresses
}

module "mssql" {
  count               = var.mssql_create_flag ? 1 : 0
  source              = "./modules/mssql"
  workload            = var.workload
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location

  sku                      = var.mssql_sku
  max_size_gb              = var.mssql_max_size_gb
  admin_login              = var.mssql_admin_login
  admin_login_password     = var.default_password
  localfw_start_ip_address = var.allowed_ip_address
  localfw_end_ip_address   = var.allowed_ip_address
}

module "ml_workspace" {
  source                        = "./modules/ml/workspace"
  workload                      = "${var.workload}${local.affix}"
  resource_group_name           = module.resource_groups.machine_learning_resource_group_name
  location                      = var.location
  public_network_access_enabled = var.mlw_public_network_access_enabled

  application_insights_id = module.monitor.application_insights_id
  storage_account_id      = module.blob_storage.storage_account_id
  key_vault_id            = module.key_vault.key_vault_id
  container_registry_id   = module.container_registry.id
}

module "ampls" {
  source                     = "./modules/private_link/scope"
  workload                   = var.workload
  resource_group_name        = module.resource_groups.machine_learning_resource_group_name
  log_analytics_workspace_id = module.monitor.log_analytics_workspace_id
  application_insights_id    = module.monitor.application_insights_id
}

module "private_link_monitor" {
  source              = "./modules/private_link/monitor"
  workload            = "${var.workload}${local.affix}"
  location            = var.location
  resource_group_name = module.resource_groups.machine_learning_resource_group_name

  vnet_id                       = module.network.vnet_id
  ampls_subnet_id               = module.network.private_endpoints_subnet_id
  monitor_private_link_scope_id = module.ampls.monitor_private_link_scope_id
  private_dns_zone_blob_id      = module.private_link_aml.private_dns_zone_blob_id
}

module "private_link_aml" {
  source                      = "./modules/private_link/aml"
  resource_group_name         = module.resource_groups.private_link_resource_group_name
  location                    = var.location
  vnet_id                     = module.network.vnet_id
  private_endpoints_subnet_id = module.network.private_endpoints_subnet_id

  aml_workspace_id             = module.machine_learning_workspace.aml_workspace_id
  container_registry_id        = module.container_registry.id
  key_vault_id                 = module.key_vault.key_vault_id
  aml_storage_account_id       = module.blob_storage.storage_account_id
  data_lake_storage_account_id = module.data_lake_storage.id

  mlw_mssql_create_flag = var.mssql_create_flag
  sql_server_id         = var.mssql_create_flag == true ? module.mssql[0].server_id : null
}

module "ml_compute" {
  source   = "./modules/ml/compute"
  count    = var.mlw_instance_create_flag ? 1 : 0
  location = var.location

  machine_learning_workspace_id = module.machine_learning_workspace.aml_workspace_id
  instance_vm_size              = var.mlw_instance_vm_size
  ssh_public_key                = var.public_key_path
  training_subnet_id            = module.network.training_subnet_id
}

module "ml_aks" {
  source              = "./modules/ml/aks"
  count               = var.mlw_aks_create_flag ? 1 : 0
  workload            = var.workload
  resource_group_name = module.resource_groups.machine_learning_resource_group_name
  location            = var.location
  vnet_id             = module.network.vnet_id

  machine_learning_workspace_id = module.machine_learning_workspace.aml_workspace_id
  scoring_subnet_id             = module.network.scoring_subnet_id
  scoring_aks_api_subnet_id     = module.network.scoring_aks_api_subnet_id
  node_count                    = var.mlw_aks_node_count
  vm_size                       = var.mlw_aks_vm_size
  container_registry_id         = module.container_registry.id
}

module "firewall" {
  count  = var.firewall_create_flag ? 1 : 0
  source = "./modules/firewall"

  machilelearning_rg_name            = module.resource_groups.network_resource_group_name
  aml_workspace_default_storage_name = module.blob_storage.storage_account_name

  workload           = var.workload
  affix              = local.affix
  location           = var.location
  region_service_tag = var.region_service_tag

  firewall_sku_tier   = var.firewall_sku_tier
  firewall_policy_sku = var.firewall_policy_sku

  machinelearning_vnet_id   = module.network.vnet_id
  machinelearning_vnet_name = module.network.vnet_name
  training_subnet_id        = module.network.training_subnet_id
  # bastion_subnet_id                = module.network.bastion_subnet_id
  training_subnet_address_prefixes = module.network.training_subnet_address_prefixes
  # bastion_subnet_address_prefixes  = module.network.bastion_subnet_address_prefixes
  training_nsg_id = "" # TODO: Network access refinement. Will implement if possible in the future.
}

module "windows11_virtual_machine" {
  source              = "./modules/virtual_machines/win11"
  workload            = var.workload
  resource_group_name = module.resource_groups.virtual_machines_resource_group_name
  location            = var.location
  size                = var.vm_size
  image_sku           = var.vm_image_sku
  subnet              = module.network.windows_subnet_id
  admin_username      = var.default_username
  admin_password      = var.default_password
}

module "squid_proxy_virtual_machine" {
  count               = var.vm_squid_proxy_create_flag ? 1 : 0
  source              = "./modules/virtual_machines/squid_proxy"
  workload            = var.workload
  resource_group_name = module.resource_groups.virtual_machines_resource_group_name
  location            = var.location
  size                = var.vm_squid_proxy_size
  subnet_id           = module.network.proxy_subnet_id
  zone_name           = module.network.private_zone_name
  public_key_path     = var.public_key_path
  offer               = var.vm_squid_proxy_offer
  sku                 = var.vm_squid_proxy_sku
  admin_username      = var.default_username
}

module "iam_administrator_permissions" {
  source             = "./modules/iam/administrator"
  user_object_id     = module.entra_users.administrator_user_object_id
  resource_group_ids = module.resource_groups.resouce_groups_ids
}

module "Iam_data_scientist_permissions" {
  source             = "./modules/iam/data_scientist"
  user_object_id     = module.entra_users.data_scientist_user_object_id
  resource_group_ids = module.resource_groups.resouce_groups_ids
  acr_id             = module.container_registry.id
}
