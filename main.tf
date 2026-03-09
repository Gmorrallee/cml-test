resource "azurerm_resource_group" "rg_identity_networking" {
  provider = azurerm.identity

  name     = "rg-identity-networking"
  location = var.location
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm.identity
  }

  name        = "vnet-identity-uks"
  parent_id  = azurerm_resource_group.rg_identity_networking.id
  location   = var.location

  address_space = ["10.100.0.0/16"],

  name        = "vnet-identity-uks"
  parent_id  = azurerm_resource_group.rg_identity_networking.id
  location   = var.location_2

  address_space = ["10.200.0.0/16"]
}


