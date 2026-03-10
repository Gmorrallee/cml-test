locals {
  nsg_rules = {
    "Bastion-Allow" = {
      name                       = "Bastion-Allow"
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
      direction                  = "Inbound"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "10.102.250.0/24"
      source_port_range          = "*"
    }
    "rule02" = {
      name                       = "Deny-Any-All"
      access                     = "Deny"
      destination_address_prefix = "*"
      destination_port_ranges    = ["*"]
      direction                  = "Inbound"
      priority                   = 4000
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }
}

module "nsg-dirservices-uks" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  location            = var.location
  name                = "nsg-dirservices-uks"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name
  security_rules      = local.nsg_rules
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-uks" {
  subnet_id                 = module.snet-dirservices-uks.resource_id
  network_security_group_id = module.nsg-dirservices-uks.resource_id
}


module "nsg-dirservices-ukw" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  location            = var.location_2
  name                = "nsg-dirservices-ukw"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name
  security_rules      = local.nsg_rules
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-ukw" {
  subnet_id                 = module.snet-dirservices-ukw.resource_id
  network_security_group_id = module.nsg-dirservices-ukw.resource_id
}


  
