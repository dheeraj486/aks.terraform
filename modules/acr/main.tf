# -----------------------------------------------------------------------------
# Azure Container Registry (Premium SKU required for private endpoint support)
# -----------------------------------------------------------------------------
resource "azurerm_container_registry" "main" {
  # ACR name must be globally unique, alphanumeric only
  name                          = "acr${replace(var.project_name, "-", "")}${substr(md5(var.resource_group_id), 0, 6)}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "Premium" # Required for private endpoint
  admin_enabled                 = false
  public_network_access_enabled = false
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Private DNS Zone for ACR
# -----------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "acr-dns-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# -----------------------------------------------------------------------------
# Private Endpoint for ACR
# -----------------------------------------------------------------------------
resource "azurerm_private_endpoint" "acr" {
  name                = "pe-acr-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-acr-${var.project_name}"
    private_connection_resource_id = azurerm_container_registry.main.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }
}

# -----------------------------------------------------------------------------
# Role Assignment: Kubelet identity gets AcrPull on ACR
# This allows AKS nodes to pull images using managed identity
# -----------------------------------------------------------------------------
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.kubelet_identity_principal_id
}
