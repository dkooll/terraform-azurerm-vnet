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

  southeastasia = {
    cidr = ["10.20.0.0/16"]
    dns  = []
    subnets = {
      sn1 = {
        cidr      = ["10.20.1.0/24"]
        endpoints = []
        rules = []
        delegations = []
      }
    }
  }

  eastus = {
    cidr = ["10.21.0.0/16"]
    dns  = []
    subnets = {
      sn1 = {
        cidr      = ["10.21.1.0/24"]
        endpoints = []
        rules = []
        delegations = []
      }
    }
  }

  southcentralus = {
    cidr = ["10.22.0.0/16"]
    dns  = []
    subnets = {
      sn1 = {
        cidr      = ["10.22.1.0/24"]
        endpoints = []
        rules = []
        delegations = []
      }
    }
  }
}