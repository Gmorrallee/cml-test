module "snet-dirservices-uks" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_identity_uksouth.resource_id
  name      = "snet-dirservices-uks"

  address_prefixes = ["10.100.10.0/24"]
}

module "snet-dirservices-ukw" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_identity_ukwest.resource_id
  name      = "snet-dirservices-ukw"

  address_prefixes = ["10.200.10.0/24"]
}

module "snet-bastion-uks" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_connectivity_uksouth.resource_id
  name      = "AzureBastionSubnet"

  address_prefixes = ["10.102.250.0/24"]
}

module "snet-bastion-ukW" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_connectivity_ukwest.resource_id
  name      = "AzureBastionSubnet"

  address_prefixes = ["10.202.250.0/24"]
}
