
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

