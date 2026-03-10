## Identity vNet 

module "vnet_identity_uksouth" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-identity-uks"
  parent_id     = azurerm_resource_group.rg_identity_networking.id
  location      = var.location
  address_space = ["10.100.0.0/16"]
}

module "identity_subnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  name      = "snet-dirservices-uks"
  parent_id = module.vnet_identity_uksouth.id

  address_prefixes = ["10.100.10.0/24"]
}



module "vnet_identity_ukwest" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-identity-ukw"
  parent_id     = azurerm_resource_group.rg_identity_networking.id
  location      = var.location_2
  address_space = ["10.200.0.0/16"]
}

## Management vNet 

module "vnet_management_uksouth" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-management-uks"
  parent_id     = azurerm_resource_group.rg_management_networking.id
  location      = var.location
  address_space = ["10.101.0.0/16"]
}

module "vnet_management_ukwest" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-management-ukw"
  parent_id     = azurerm_resource_group.rg_management_networking.id
  location      = var.location_2
  address_space = ["10.201.0.0/16"]
}

## Connectivity vNet 

module "vnet_connectivity_uksouth" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-connectivity-uks"
  parent_id     = azurerm_resource_group.rg_connectivity_networking.id
  location      = var.location
  address_space = ["10.102.0.0/16"]
}

module "vnet_connectivity_ukwest" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm
  }

  name          = "vnet-connectivity-ukw"
  parent_id     = azurerm_resource_group.rg_connectivity_networking.id
  location      = var.location_2
  address_space = ["10.202.0.0/16"]
}


