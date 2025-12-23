variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "sku" {
  type = string
}

variable "max_size_gb" {
  type = number
}

variable "admin_login" {
  type = string
}

variable "admin_login_password" {
  type      = string
  sensitive = true
}

variable "local_firewall_allowed_ip_addresses" {
  type = list(string)
}
