module "nsg-dirservices-uks" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  location            = var.location
  name                = "nsg-dirservices-uks"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name
}

  
