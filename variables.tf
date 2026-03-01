variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "aksdemo"
}

variable "location" {
  description = "Azure region for all resources (eastus is among the cheapest)"
  type        = string
  default     = "eastus"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "appgw_subnet_prefix" {
  description = "Address prefix for the Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.4.0/24"]
}

variable "pe_subnet_prefix" {
  description = "Address prefix for the Private Endpoints subnet"
  type        = list(string)
  default     = ["10.0.5.0/24"]
}

variable "aks_node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes (Standard_B2s is cheapest option for AKS)"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.28"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
