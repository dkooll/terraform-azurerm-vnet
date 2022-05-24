![example workflow](https://github.com/dkooll/terraform-azurerm-vnet/actions/workflows/validate.yml/badge.svg)

# Virtual Network

Terraform module which creates VNET resources on Azure. It references a single object called vnet, which contains nested keys. To be able to reference these nested key values, a list of maps is created using a local variable.
Using this approach we are able to build a logical data structure. The basic principle is that the consumer needs to apply as little logic as possible.

The code base is validated using [terratest](https://terratest.gruntwork.io/). These tests can be found [here](tests).

The [example](examples) directory is used as the working directory. If needed it contains prerequirements and integrations to test the code.

The usage examples below show which features can be enabled and applied.

## Usage: single vnet multiple dns

```hcl
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  resourcegroup = "rg-network-dev"
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

## Usage: single vnet multiple subnets

```hcl
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  resourcegroup = "rg-network-dev"
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

## Usage: multiple vnets single subnet with endpoints

```hcl
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  resourcegroup = "rg-network-dev"
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

## Usage: single vnet single subnet with delegations

```hcl
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  resourcegroup = "rg-network-dev"
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

## Usage: multiple vnets single subnet with multiple nsg rules

```hcl
module "vnet" {
  source = "github.com/dkooll/terraform-azurerm-vnet"
  resourcegroup = "rg-network-dev"
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
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vnets` | describes vnet related configuration | object | yes |
| `resourcegroup` | name of the resource group | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `subnets` | contains all subnets |
| `vnets` | contains all vnets |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/dkooll/terraform-azurerm-vnet/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/dkooll/terraform-azurerm-vnet/tree/master/LICENSE) for full details.