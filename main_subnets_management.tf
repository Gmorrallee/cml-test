module "snet_mgmt_management_uks" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_management_uksouth.resource_id
  name      = "snet-management-uks"

  address_prefixes = ["10.101.50.0/24"]
}

module "snet_mgmt_management_ukw" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_management_ukwest.resource_id
  name      = "snet-management-ukw"

  address_prefixes = ["10.201.50.0/24"]
}

