# -----------------------------------------------------------------------------
# AKS Cluster - Private, with Istio Service Mesh
# -----------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "main" {
  name                    = "aks-${var.project_name}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "aks-${var.project_name}"
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = false
  sku_tier                = "Free"
  tags                    = var.tags

  # Single VMSS node pool
  default_node_pool {
    name                        = "system"
    node_count                  = var.node_count
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.aks_subnet_id
    type                        = "VirtualMachineScaleSets"
    os_disk_size_gb             = 30
    os_disk_type                = "Managed"
    max_pods                    = 30
    temporary_name_for_rotation = "tmppool"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  # System-assigned + user-assigned identity for the AKS control plane
  identity {
    type         = "SystemAssigned"
    identity_ids = [var.aks_identity_id]
  }

  # User-assigned identity for kubelet (ACR pull, etc.)
  kubelet_identity {
    client_id                 = var.kubelet_identity_client_id
    object_id                 = var.kubelet_identity_principal_id
    user_assigned_identity_id = var.kubelet_identity_id
  }

  # Network configuration - Azure CNI with NAT Gateway for outbound
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    outbound_type       = "loadBalancer"
    service_cidr        = "10.1.0.0/16"
    dns_service_ip      = "10.1.0.10"
    pod_cidr            = "10.2.0.0/16"
  }

  # Istio Service Mesh addon with internal ingress gateway
  service_mesh_profile {
    mode                          = "Istio"
    internal_ingress_gateway_enabled = true
  }
}
