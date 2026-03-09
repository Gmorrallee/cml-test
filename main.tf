resource "azurerm_resource_group" "identity" {
  name     = "rg-identity-prod"
  location = var.location
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  name                = "vnet-identity"
  resource_group_name = azurerm_resource_group.identity.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]
}
