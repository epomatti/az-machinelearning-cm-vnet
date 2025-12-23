### General ###
variable "location" {
  type = string
}

variable "region_service_tag" {
  description = "value to be used in the service tag for the region"
  type        = string
}

variable "workload" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "allowed_ip_addresses" {
  type = list(string)
}

### Shared ###
variable "default_username" {
  type = string
}

variable "default_password" {
  type      = string
  sensitive = true
}

### VNET ###
variable "vnet_training_nsg_source_address_prefix" {
  type = string
}

variable "vnet_training_nsg_destination_address_prefix" {
  type = string
}

### Bastion ###
variable "create_bastion_host" {
  type = bool
}

variable "bastion_host_sku" {
  type = string
}

### Keys ###
variable "public_key_path" {
  type = string
}

### AML ###
variable "mlw_instance_create_flag" {
  type = bool
}

variable "mlw_instance_vm_size" {
  type = string
}

variable "mlw_public_network_access_enabled" {
  type = bool
}

### AKS ###
variable "mlw_aks_create_flag" {
  type = bool
}

variable "mlw_aks_node_count" {
  type = number
}

variable "mlw_aks_vm_size" {
  type = string
}

### MSSQL ###
variable "mssql_create_flag" {
  type = bool
}

variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_admin_login" {
  type = string
}

### Virtual Machine: Windows 11 Jump Server ###
variable "vm_size" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

### Virtual Machine: Squid Proxy ###
variable "vm_squid_proxy_create_flag" {
  type = bool
}

variable "vm_squid_proxy_size" {
  type = string
}

variable "vm_squid_proxy_offer" {
  type = string
}

variable "vm_squid_proxy_sku" {
  type = string
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_data_scientist_username" {
  type = string
}

variable "entraid_administrator_username" {
  type = string
}

### Firewall ###
variable "firewall_create_flag" {
  type = bool
}

variable "firewall_sku_tier" {
  type = string
}

variable "firewall_policy_sku" {
  type = string
}
