# -----------------------------------------------------------------------------
# User-Assigned Managed Identity for AKS Control Plane
# -----------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# User-Assigned Managed Identity for AKS Kubelet (node pool / ACR access)
# -----------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "kubelet" {
  name                = "id-aks-kubelet-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Role Assignments
# -----------------------------------------------------------------------------

# AKS control plane identity needs Managed Identity Operator on kubelet identity
resource "azurerm_role_assignment" "aks_mi_operator" {
  scope                = azurerm_user_assigned_identity.kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# AKS control plane identity needs Network Contributor on the AKS subnet
resource "azurerm_role_assignment" "aks_subnet_contributor" {
  scope                = var.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# AKS control plane identity needs Network Contributor on the VNet
resource "azurerm_role_assignment" "aks_vnet_contributor" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
