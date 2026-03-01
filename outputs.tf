# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.networking.resource_group_name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = module.acr.login_server
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = module.acr.acr_name
}

output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway (ingress point)"
  value       = module.appgateway.public_ip_address
}

output "aks_identity_client_id" {
  description = "Client ID of the AKS control plane managed identity"
  value       = module.identity.aks_identity_client_id
}

output "kubelet_identity_client_id" {
  description = "Client ID of the kubelet managed identity (used for ACR pull)"
  value       = module.identity.kubelet_identity_client_id
}

output "aks_get_credentials_command" {
  description = "Azure CLI command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${module.networking.resource_group_name} --name ${module.aks.cluster_name}"
}
