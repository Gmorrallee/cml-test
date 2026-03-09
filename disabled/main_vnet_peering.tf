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

module "management_vnet_peering" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.17"

  name                      = "vnet-management-uksouth-to-vnet-management-ukwest"
  parent_id                 = module.vnet_management_uksouth.resource_id
  remote_virtual_network_id = module.vnet_management_ukwest.resource_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  create_reverse_peering = true
  reverse_name           = "vnet-management-ukwest-to-vnet-management-uksouth"
}

module "connectivity_vnet_peering" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.17"

  name                      = "vnet-connectivity-uksouth-to-vnet-connectivity-ukwest"
  parent_id                 = module.vnet_connectivity_uksouth.resource_id
  remote_virtual_network_id = module.vnet_connectivity_ukwest.resource_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  create_reverse_peering = true
  reverse_name           = "vnet-connectivity-ukwest-to-vnet-connectivity-uksouth"
}
