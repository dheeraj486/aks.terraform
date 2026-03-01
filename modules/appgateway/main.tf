# -----------------------------------------------------------------------------
# Public IP for Application Gateway
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Application Gateway v2 (serves as the ingress point for AKS via AGIC)
# Standard_v2 is the minimum SKU required for AGIC integration
# -----------------------------------------------------------------------------
locals {
  appgw_name                 = "appgw-${var.project_name}"
  frontend_ip_config_name    = "appgw-frontend-ip"
  frontend_port_name         = "appgw-frontend-port"
  backend_address_pool_name  = "appgw-backend-pool"
  backend_http_settings_name = "appgw-backend-http"
  http_listener_name         = "appgw-http-listener"
  routing_rule_name          = "appgw-routing-rule"
}

resource "azurerm_application_gateway" "main" {
  name                = local.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  # Use autoscaling with min 0 to minimize costs on free account
  autoscale_configuration {
    min_capacity = 0
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = var.appgw_subnet_id
  }

  # Use modern TLS policy - AppGwSslPolicy20150501 is deprecated
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  # Placeholder backend pool - AGIC will manage actual backends
  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
  }

  # Ignore changes managed by AGIC after initial deployment
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      redirect_configuration,
      url_path_map,
      ssl_certificate,
      tags["managed-by-k8s-ingress"],
    ]
  }
}
