resource "azurerm_resource_group" "identity" {
  name     = "rg-identity-prod"
  location = var.location
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  name       = "vnet-identity"
  parent_id = azurerm_resource_group.identity.id
  location  = var.location

  address_space = ["10.10.0.0/16"]
}

