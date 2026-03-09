
module "vnet_identity_uksouth" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm.identity
  }

  name          = "vnet-identity-uks"
  parent_id     = azurerm_resource_group.rg_identity_networking.id
  location      = var.location
  address_space = ["10.100.0.0/16"]
}

module "vnet_identity_ukwest" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm.identity
  }

  name          = "vnet-identity-ukw"
  parent_id     = azurerm_resource_group.rg_identity_networking.id
  location      = var.location_2
  address_space = ["10.200.0.0/16"]
}

# -----------------------------
# VNet Peering (AVM submodule)
# -----------------------------

module "identity_vnet_peering" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.17"

  name                      = "vnet-identity-uksouth-to-vnet-identity-ukwest"
  parent_id                 = module.vnet_identity_uksouth.resource_id
  remote_virtual_network_id = module.vnet_identity_ukwest.resource_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  create_reverse_peering = true
  reverse_name           = "vnet-identity-ukwest-to-vnet-identity-uksouth"
}

