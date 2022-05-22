locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet_key, subnet in try(network.subnets, {}) : {

        network_key          = network_key
        subnet_key           = subnet_key
        address_prefixes     = subnet.cidr
        subnet_name          = "sn-${var.env}-${network_key}-${subnet_key}"
        nsg_name             = "nsg-${var.env}-${network_key}-${subnet_key}"
        location             = network.location
        resource_group_name  = network.rg
        endpoints            = try(subnet.endpoints, [])
        rules                = try(subnet.rules, {})
        delegations          = try(subnet.delegations, [])
        virtual_network_name = azurerm_virtual_network.vnets[network_key].name
      }
    ]
  ])
}
