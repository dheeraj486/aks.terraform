output "aks_identity_id" {
  description = "ID of the AKS control plane user-assigned identity"
  value       = azurerm_user_assigned_identity.aks.id
}

output "aks_identity_client_id" {
  description = "Client ID of the AKS control plane user-assigned identity"
  value       = azurerm_user_assigned_identity.aks.client_id
}

output "aks_identity_principal_id" {
  description = "Principal ID of the AKS control plane user-assigned identity"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "kubelet_identity_id" {
  description = "ID of the kubelet user-assigned identity"
  value       = azurerm_user_assigned_identity.kubelet.id
}

output "kubelet_identity_client_id" {
  description = "Client ID of the kubelet user-assigned identity"
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

output "kubelet_identity_principal_id" {
  description = "Principal ID of the kubelet user-assigned identity"
  value       = azurerm_user_assigned_identity.kubelet.principal_id
}
