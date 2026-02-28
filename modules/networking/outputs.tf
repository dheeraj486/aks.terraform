output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.appgw.id
}

output "pe_subnet_id" {
  description = "ID of the Private Endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.main.id
}
