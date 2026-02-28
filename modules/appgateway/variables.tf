variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}
