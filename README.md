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
    - [Usage: `multiple vnets single subnet with nsg rules`](#inputs-usage-multiple-vnets-single-subnet-with-nsg-rules)
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
| `vnets` | describes vnet related configuration | object | yes |

### Usage: `single vnet multiple dns`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet?ref=1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      dns      = ["8.8.8.8","7.7.7.7"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr        = ["10.18.1.0/24"]
          endpoints   = []
          delegations = []
          rules       = []
        }
      }
    }
  }
}
```

### Usage: `single vnet multiple subnets`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet?ref=1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      dns      = ["8.8.8.8"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr        = ["10.18.1.0/24"]
          endpoints   = []
          delegations = []
          rules       = []
        }
        sn2 = {
          cidr        = ["10.18.2.0/24"]
          endpoints   = []
          delegations = []
          rules       = []
        }
      }
    }
  }
}
```

### Usage: `multiple vnets single subnet with endpoints`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet?ref=1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      dns      = ["8.8.8.8"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr        = ["10.18.1.0/24"]
          endpoints   = ["Microsoft.Storage", "Microsoft.Sql"]
          delegations = []
          rules       = []
        }
      }
    }

    vnet2 = {
      cidr     = ["10.19.0.0/16"]
      dns      = []
      location = "eastus2"
      subnets = {
        sn1 = {
          cidr        = ["10.19.1.0/24"]
          endpoints   = ["Microsoft.Web"]
          delegations = []
          rules       = []
        }
      }
    }
  }
}
```

### Usage: `single vnet single subnet with delegations`

```terraform
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet?ref=1.0.0"
  vnets = {
    vnet1 = {
      cidr     = ["10.18.0.0/16"]
      dns      = ["8.8.8.8"]
      location = "westeurope"
      subnets = {
        sn1 = {
          cidr        = ["10.18.1.0/24"]
          endpoints   = []
          delegations = [
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.Kusto/clusters",
            "Microsoft.Sql/managedInstances"
          ]
          rules       = []
        }
      }
    }
  }
}
```

### Usage: `single vnet single subnet with nsg rules`

## Outputs

## References