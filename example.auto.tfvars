vnets = {
  vnet1 = {
    cidr = ["10.18.0.0/16"]
    dns  = ["8.8.8.8"]
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

  vnet2 = {
    cidr = ["10.19.0.0/16"]
    dns  = []
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