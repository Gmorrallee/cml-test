module "snet_dirservices-uks" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_identity_uksouth.resource_id
  name      = "snet-${each.key}-uks"
  address_prefixes = each.value.address_prefixes

}

module "snet_dirservices-ukw" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "~> 0.17"

  parent_id = module.vnet_identity_ukwest.resource_id
  name      = "snet-${each.key}-ukW"
  address_prefixes = each.value.address_prefixes

}
