module "rg" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.4"

  name     = "rg-identity-prod"
  location = var.location
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.7"

  name                = "vnet-identity"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]
}
