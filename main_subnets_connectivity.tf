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
