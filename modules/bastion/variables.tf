variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet" {
  type = string
}

variable "sku" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "zones" {
  type = list(string)
}
