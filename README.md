## Virtual Network `[Microsoft.Network/virtualNetworks]`

This module deploys an Virtual Network.

## Table of Contents

- [Virtual Network](#virtual-network)
  - [**Table of Contents**](#table-of-contents)
  - [Resources](#resources)
  - [Inputs](#inputs)
    - [Input Usage: `network`](#inputs-usage-network)
  - [Outputs](#outputs)
  - [Template references](#template-references)

## Resources

| Name | Type |
| :-- | :-- |
| `azurerm_resource_group` | resource |
| `azurerm_virtual_network` | resource |
| `azurerm_virtual_network_dns_servers` | resource |
| `azurerm_subnet` | resource |
| `azurerm_network_security_group` | resource |
| `azurerm_subnet_network_security_group_association` | resource |

## Inputs

| Name | Type | Description | Required
| :-- | :-- | :-- | :-- | :-- |
| `vnetName` | object |  |  | describes vnet related configuration | yes

### Input Usage: `network`

```terraform
network = {
  westeurope = {
    cidr = ["10.18.0.0/16"]
    dns  = ["8.8.8.8"]
    subnets = {
      sn1 = {
        cidr      = ["10.18.1.0/24"]
        endpoints = []
        delegations = []
        rules = []
      }
    }
  }

  eastus2 = {
    cidr     = ["10.19.0.0/16"]
    dns      = []
    subnets = {
      sn1 = {
        cidr      = ["10.19.1.0/24"]
        endpoints = []
        rules = []
        delegations = []
      }
    }
  }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `virtualNetworkName` | string | The name of the virtual network |
| `virtualNetworkResourceId` | string | The resourceId of the virtual network |
| `subnetNames` | array | The names of the subnets |
| `subnetIds` | array | The resourceId of the subnets |


## Template references

- [virtualnetworks](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep)
- [nsg](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups?tabs=bicep)
- [nsgrules](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups/securityrules?tabs=bicep)
