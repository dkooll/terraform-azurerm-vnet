# output "network" {
#   value = local.network_subnets
# }

output "subnets" {
  value = azurerm_subnet.subnets
}

output "vnets" {
  value = azurerm_virtual_network.vnets
}

output "resourcegroup" {
  value = azurerm_resource_group.rg.name
}