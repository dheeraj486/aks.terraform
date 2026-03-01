# -----------------------------------------------------------------------------
# Private AKS Environment with NAT Gateway, App Gateway, Istio & Managed Identity
# -----------------------------------------------------------------------------
# Architecture:
#   Internet → Application Gateway (public IP) → AKS Pods (private cluster)
#   AKS Pods → NAT Gateway → Internet (outbound)
#   AKS → ACR via Private Endpoint using User-Assigned Managed Identity
#   Istio Service Mesh for internal service-to-service communication
# -----------------------------------------------------------------------------

# --- Networking: VNet, Subnets, NAT Gateway, NSGs ---
module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  location            = var.location
  vnet_address_space  = var.vnet_address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  appgw_subnet_prefix = var.appgw_subnet_prefix
  pe_subnet_prefix    = var.pe_subnet_prefix
  tags                = var.tags
}

# --- Identity: User-Assigned Managed Identities for AKS & Kubelet ---
module "identity" {
  source = "./modules/identity"

  project_name        = var.project_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  aks_subnet_id       = module.networking.aks_subnet_id
  vnet_id             = module.networking.vnet_id
  tags                = var.tags
}

# --- ACR: Container Registry with Private Endpoint ---
module "acr" {
  source = "./modules/acr"

  project_name                  = var.project_name
  location                      = var.location
  resource_group_name           = module.networking.resource_group_name
  resource_group_id             = module.networking.resource_group_id
  pe_subnet_id                  = module.networking.pe_subnet_id
  vnet_id                       = module.networking.vnet_id
  kubelet_identity_principal_id = module.identity.kubelet_identity_principal_id
  tags                          = var.tags
}

# --- Application Gateway: Ingress point for the AKS cluster ---
module "appgateway" {
  source = "./modules/appgateway"

  project_name        = var.project_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  appgw_subnet_id     = module.networking.appgw_subnet_id
  tags                = var.tags
}

# --- AKS: Private Cluster with Istio, AGIC, and Managed Identity ---
module "aks" {
  source = "./modules/aks"

  project_name                  = var.project_name
  location                      = var.location
  resource_group_name           = module.networking.resource_group_name
  resource_group_id             = module.networking.resource_group_id
  kubernetes_version            = var.kubernetes_version
  aks_subnet_id                 = module.networking.aks_subnet_id
  app_gateway_id                = module.appgateway.app_gateway_id
  appgw_subnet_id               = module.networking.appgw_subnet_id
  kubelet_identity_id           = module.identity.kubelet_identity_id
  kubelet_identity_client_id    = module.identity.kubelet_identity_client_id
  kubelet_identity_principal_id = module.identity.kubelet_identity_principal_id
  node_count                    = var.aks_node_count
  vm_size                       = var.aks_vm_size
  tags                          = var.tags
}
