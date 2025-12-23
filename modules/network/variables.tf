variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "allowed_ip_addresses" {
  type = list(string)
}

variable "training_nsg_source_address_prefix" {
  type = string
}

variable "training_nsg_destination_address_prefix" {
  type = string
}
