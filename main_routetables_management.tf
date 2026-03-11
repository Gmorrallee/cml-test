module "rt-mgmt-management-uks" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "0.5.0"

location = var.location
name = "rt-mgmt-management-uks"
  resource_group_name = azurerm_resource_group.rg_management_networking.name
}

module "rt-mgmt-management-ukw" {
  source  = "Azure/avm-res-network-routetable/azurerm//examples/complete-example"
  version = "0.5.0"

location = var.location_2
name = "rt-mgmt-management-ukw"
  resource_group_name = azurerm_resource_group.rg_management_networking.name
}
