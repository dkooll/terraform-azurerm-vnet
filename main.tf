provider "azurerm" {
  features {}
}

#----------------------------------------------------------------------------------------
# Resourcegroups
#----------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = "rg-network-${var.env}-001"
  location = "westeurope"
}

#----------------------------------------------------------------------------------------
# Vnets
#----------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = "vnet-${var.env}-${each.value.location}-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = each.value.location
  address_space       = each.value.cidr

  ddos_protection_plan {
    id      = azurerm_network_ddos_protection_plan.ddos_plan.id
    enabled = each.value.ddos_plan
  }
}

#----------------------------------------------------------------------------------------
# Dns
#----------------------------------------------------------------------------------------

resource "azurerm_virtual_network_dns_servers" "dns" {
  for_each = var.vnets

  virtual_network_id = azurerm_virtual_network.vnets[each.key].id
  dns_servers        = lookup(each.value, "dns", null)
}

#----------------------------------------------------------------------------------------
# Subnets
#----------------------------------------------------------------------------------------

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

resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "endpoints", null)

  dynamic "delegation" {
    for_each = each.value.delegations

    content {
      name = "delegation"

      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

#----------------------------------------------------------------------------------------
# Nsg's
#----------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  name                = each.value.nsg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = each.value.location

  dynamic "security_rule" {
    for_each = each.value.rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

#----------------------------------------------------------------------------------------
# Nsg subnet associations
#----------------------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "nsg_as" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

#----------------------------------------------------------------------------------------
# Ddos protection plan
#----------------------------------------------------------------------------------------

resource "azurerm_network_ddos_protection_plan" "ddos_plan" {
  for_each = var.vnets

  name                = "plan-ddos-${var.env}-001"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg.name
}