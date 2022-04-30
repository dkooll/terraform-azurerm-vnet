## Virtual Network `[Microsoft.Network/virtualNetworks]`

Terraform module which creates VNET resources on Azure. It's core features include:

- seperate config from module
- multiple VNETs
- multiple subnets per VNET
- NSG per subnet
- multiple security rules per NSG

## Table of Contents

- [Virtual Network](#virtual-network)
  - [**Table of Contents**](#table-of-contents)
  - [Resources](#resources)
  - [Inputs](#inputs)
    - [Usage: `network`](#inputs-usage-network)
  - [Outputs](#outputs)
  - [References](#references)

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

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `azurerm_resource_group` | describes vnet related configuration | object | yes |

### Usage: `network`

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

## References