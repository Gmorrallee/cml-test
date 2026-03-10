module "nsg-dirservices-uks" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  location            = var.location
  name                = "nsg-dirservices-uks"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-uks" {
  subnet_id                 = data.azurerm_subnet.snet-dirservices-uks.id
  network_security_group_id = module.nsg-dirservices-uks.resource_id
}


module "nsg-dirservices-ukw" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  location            = var.location
  name                = "nsg-dirservices-ukw"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-ukw" {
  subnet_id                 = data.azurerm_subnet.snet-dirservices-ukw.id
  network_security_group_id = module.nsg-dirservices-uks.resource_id
}


  
