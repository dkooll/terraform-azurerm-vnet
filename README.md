![example workflow](https://github.com/dkooll/terraform-azurerm-vnet/actions/workflows/validate.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Virtual Network

Terraform module which creates VNET resources on Azure.

## Usage

single vnet multiple dns

```hcl
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

single vnet multiple subnets

```hcl
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

multiple vnets single subnet with endpoints

```hcl
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

single vnet single subnet with delegations

```hcl
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

multiple vnets single subnet with multiple nsg rules

```hcl
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

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [azurerm_virtual_network_dns_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vnets` | describes vnet related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `subnets` | contains all subnets |
| `vnets` | contains all vnets |
