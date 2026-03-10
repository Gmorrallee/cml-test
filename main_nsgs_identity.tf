module "nsg-dirservices-uks" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm//examples/default"
  version = "0.5.1"

  providers = {
    azurerm = azurerm
  }

  location var.location
  name = "nsg-dirservices-uks"
  parent_id     = azurerm_resource_group.rg_identity_networking.id
  }
  
