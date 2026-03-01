variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
}

variable "appgw_subnet_prefix" {
  description = "Address prefix for the Application Gateway subnet"
  type        = list(string)
}

variable "pe_subnet_prefix" {
  description = "Address prefix for the Private Endpoints subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}
