resource "azurerm_resource_group" "rg-identity-networking" {
  name     = "rg-identity-networking"
  location = var.location
  providers = {
    azurerm = var.identity_subscription_id
  }

}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  name       = "vnet-identity-uks"
  parent_id = azurerm_resource_group.rg-identity-networking.id
  location  = var.location

  address_space = ["10.100.0.0/16"]
}

