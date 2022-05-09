locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet_key, subnet in network.subnets : {

        network_key          = network_key
        subnet_key           = subnet_key
        address_prefixes     = subnet.cidr
        subnet_name          = "sn-${var.env}-${network_key}-001"
        nsg_name             = "nsg-${var.env}-${network_key}-001"
        location             = network.location
        endpoints            = subnet.endpoints
        rules                = subnet.rules
        delegations          = subnet.delegations
        virtual_network_name = azurerm_virtual_network.vnets[network_key].name
      }
    ]
  ])
}