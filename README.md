![example workflow](https://github.com/dkooll/terraform-azurerm-vnet/actions/workflows/validate.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Open: Issues](https://img.shields.io/github/issues-raw/dkooll/terraform-azurerm-vnet?color=yellow)
![Closed: Issues](https://img.shields.io/github/issues-closed-raw/dkooll/terraform-azurerm-vnet?color=%20)

## Virtual Network `[Microsoft.Network/virtualNetworks]`

Terraform module which creates VNET resources on Azure.

## Table of Contents

- [Virtual Network](#virtual-network)
  - [**Table of Contents**](#table-of-contents)
  - [Resources](#resources)
  - [Inputs](#inputs)
    - [Usage: `single vnet multiple dns`](#inputs-usage-single-vnet-multiple-dns)
    - [Usage: `single vnet multiple subnets`](#inputs-usage-single-vnet-multiple-subnets)
    - [Usage: `multiple vnets single subnet with endpoints`](#inputs-usage-multiple-vnets-single-subnet-with-endpoints)
    - [Usage: `single vnet single subnet with delegations`](#inputs-usage-single-vnet-single-subnet-with-delegations)
    - [Usage: `multiple vnets single subnet with multiple nsg rules`](#inputs-usage-multiple-vnets-single-subnet-with-multiple-nsg-rules)
  - [Outputs](#outputs)

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
| `vnets` | describes vnet related configuration | object | yes |

### Usage: `single vnet multiple dns`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  version = "1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      dns      = ["8.8.8.8","7.7.7.7"]
      location = "westeurope"
      subnets = {
        sn1 = {cidr = ["10.18.1.0/24"]}
      }
    }
  }
}
```

### Usage: `single vnet multiple subnets`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  version = "1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      location = "westeurope"
      subnets = {
        sn1 = {cidr = ["10.18.1.0/24"]}
        sn2 = {cidr = ["10.18.2.0/24"]}
      }
    }
  }
}
```

### Usage: `multiple vnets single subnet with endpoints`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  version = "1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          endpoints = [
            "Microsoft.Storage",
            "Microsoft.Sql"
          ]
        }
      }
    }

    vnet2 = {
      cidr     = ["10.19.0.0/16"]
      location = "eastus2"
      subnets = {
        sn1 = {
          cidr = ["10.19.1.0/24"]
          endpoints = [
            "Microsoft.Web"
          ]
        }
      }
    }
  }
}
```

### Usage: `single vnet single subnet with delegations`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  version = "1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          delegations = [
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.Kusto/clusters",
            "Microsoft.Sql/managedInstances"
          ]
        }
      }
    }
  }
}
```

### Usage: `multiple vnets single subnet with multiple nsg rules`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  version = "1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          rules = [
            {name = "myhttps",priority = 100,direction = "Inbound",access = "Allow",protocol = "Tcp",source_port_range = "*",destination_port_range = "443",source_address_prefix = "10.151.1.0/24",destination_address_prefix = "*"},
            {name = "mysql",priority = 200,direction = "Inbound",access = "Allow",protocol = "Tcp",source_port_range = "*",destination_port_range = "3306",source_address_prefix = "10.0.0.0/24",destination_address_prefix = "*"}
          ]
        }
      }
    }

    vnet2 = {
      cidr     = ["10.19.0.0/16"]
      location = "eastus2"
      subnets = {
        sn1 = {
          cidr = ["10.19.1.0/24"]
          rules = [
            {name = "myssh",priority = 100,direction = "Inbound",access = "Allow",protocol = "Tcp",source_port_range = "*",destination_port_range = "22",source_address_prefix = "10.151.0.0/24",destination_address_prefix = "*"}
          ]
        }
      }
    }
  }
}
```

## Outputs

| Name | Description |
| :-- | :-- |
| `subnets` | contains all subnets |
| `vnets` | contains all vnets |
