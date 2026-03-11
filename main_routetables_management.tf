module "rt_mgmt_management_uks" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "0.5.0"

  providers = {
    azurerm = azurerm.management
  }

  name                = "rt-mgmt-management-uks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_management_networking.name


routes = {
  internet = {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address    = var.firewall_ip_uks
  }
}
  subnet_resource_ids = {
  mgmt = module.snet_mgmt_management_uks.resource_id
  }

}


module "rt_mgmt_management_ukw" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "0.5.0"

  providers = {
    azurerm = azurerm.management
  }

  name                = "rt-mgmt-management-ukw"
  location            = var.location_2
  resource_group_name = azurerm_resource_group.rg_management_networking.name


routes = {
  internet = {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address    = var.firewall_ip_ukw
  }
}

#  subnet_resource_ids = {
#    mgmt = module.snet_mgmt_management_ukw.resource_id
#  }

}
