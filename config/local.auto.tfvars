# Project
location           = "brazilsouth"
region_service_tag = "BrazilSouth"
workload           = "litware"
subscription_id    = "<1111111-2222-3333-4444-555555555555>"

# The IPv4 from where you'll access the resources
allowed_ip_addresses = ["<x.x.x.x>/30"]

# Shared
default_username = "azureuser"
default_password = "P@ssw0rd.123"

# Virtual Network
vnet_training_nsg_source_address_prefix      = "VirtualNetwork" # *, VirtualNetwork
vnet_training_nsg_destination_address_prefix = "*"              # *,Internet, VirtualNetwork

# Bastion Host
create_bastion_host = true
bastion_host_sku    = "Developer"

# Key Pair
public_key_path = ".keys/azure.pub"

# Machine Learning - Training
mlw_instance_create_flag          = false
mlw_instance_vm_size              = "STANDARD_D2AS_V4"
mlw_public_network_access_enabled = false

# Machine Learning - AKS
mlw_aks_create_flag = false
mlw_aks_node_count  = 1
mlw_aks_vm_size     = "Standard_D2as_V4"

# MSSQL
mssql_create_flag = false
mssql_sku         = "Basic"
mssql_max_size_gb = 2
mssql_admin_login = "sqladmin"

# Virtual Machine: Windows 11 Jump Server
vm_size      = "Standard_B8as_v2"
vm_image_sku = "win11-25h2-pro"

# Virtual Machine: Squid Proxy
vm_squid_proxy_create_flag = false
vm_squid_proxy_size        = "Standard_B2ls_v2"
vm_squid_proxy_offer       = "ubuntu-24_04-lts"
vm_squid_proxy_sku         = "server"

# Users
entraid_tenant_domain           = "<example.com>"
entraid_administrator_username  = "azureadmin"
entraid_data_scientist_username = "datascientist"

# Firewall
firewall_create_flag = false
firewall_sku_tier    = "Standard"
firewall_policy_sku  = "Standard"
