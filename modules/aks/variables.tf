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

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet"
  type        = string
}

variable "app_gateway_id" {
  description = "ID of the Application Gateway for AGIC integration"
  type        = string
}

variable "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet (for AGIC Network Contributor role)"
  type        = string
}

variable "aks_identity_id" {
  description = "ID of the user-assigned identity for AKS control plane"
  type        = string
}

variable "aks_identity_principal_id" {
  description = "Principal ID of the user-assigned identity for AKS control plane"
  type        = string
}

variable "kubelet_identity_id" {
  description = "ID of the user-assigned identity for kubelet"
  type        = string
}

variable "kubelet_identity_client_id" {
  description = "Client ID of the user-assigned identity for kubelet"
  type        = string
}

variable "kubelet_identity_principal_id" {
  description = "Principal ID of the user-assigned identity for kubelet"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}
