
resource "azurerm_resource_group" "rg_management_management" {
  provider = azurerm.management
  name     = "rg-management-management"
  location = var.location
}

resource "azurerm_resource_group" "rg_management_networking" {
  provider = azurerm.management
  name     = "rg-management-networking"
  location = var.location
}

resource "azurerm_resource_group" "rg_identity_networking" {
  provider = azurerm.identity
  name     = "rg-identity-networking"
  location = var.location
}

resource "azurerm_resource_group" "rg_identity_management" {
  provider = azurerm.identity
  name     = "rg-identity-management"
  location = var.location
}

resource "azurerm_resource_group" "rg_identity_dirservices" {
  provider = azurerm.identity
  name     = "rg-identity-dirservices"
  location = var.location
}

resource "azurerm_resource_group" "rg_connectivity_management" {
  provider = azurerm.connectivity
  name     = "rg-connectivity-management"
  location = var.location
}

