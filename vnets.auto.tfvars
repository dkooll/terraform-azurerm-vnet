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
        rules       = [
        {
          name                       = "myhttps"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          description                = ""
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "10.151.1.0/24"
          destination_address_prefix = "*"
        },
        {
          name                       = "mysql"
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          description                = "mysql"
          source_port_range          = "*"
          destination_port_range     = "3306"
          source_address_prefix      = "10.0.0.0/24"
          destination_address_prefix = "*"
        }
        ]
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
        endpoints   = []
        rules       = []
        delegations = []
      }
    }
  }
}