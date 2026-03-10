locals {
  # 1) Capture the destination CIDR for each subnet (prefer address_prefixes if you use multiple)
  subnet_dest = {
    uks = one(module.snet-dirservices-uks.address_prefixes)  # or module.snet-dirservices-uks.address_prefix
    ukw = one(module.snet-dirservices-ukw.address_prefixes)

  dest_any_rules = toset([
    "deny-all-any"   
  ])
  }

  # 2) Base rule template (no destination set here)
  nsg_rules_base = {
    "Bastion-Allow" = {
      name                    = "Bastion-Allow"
      access                  = "Allow"
      direction               = "Inbound"
      priority                = 100
      protocol                = "Tcp"
      source_address_prefixes = ["10.102.250.0/24","10.103.250.0/24"]
      source_port_range       = "*"
      destination_port_ranges = ["22","3389"]
    }
    "deny-all-any" = {
      name                       = "Deny-Any-All"
      access                     = "Deny"
      direction                  = "Inbound"
      priority                   = 4000
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
    }
  }

  # 3) Derive per-NSG rules by injecting destination_address_prefix

nsg_rules_dirservices_uks = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      { destination_address_prefix = local.subnet_dest.uks },
      contains(local.dest_any_rules, k) ? { destination_address_prefix = "*" } : {}
    )
  }

  nsg_rules_dirservices_ukw = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      { destination_address_prefix = local.subnet_dest.ukw },
      contains(local.dest_any_rules, k) ? { destination_address_prefix = "*" } : {}
    )
  }

}

module "nsg-dirservices-uks" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"
  location            = var.location
  name                = "nsg-dirservices-uks"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name

  security_rules      = local.nsg_rules_dirservices_uks
}

module "nsg-dirservices-ukw" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"
  location            = var.location_2
  name                = "nsg-dirservices-ukw"
  resource_group_name = azurerm_resource_group.rg_identity_networking.name

  security_rules      = local.nsg_rules_dirservices_ukw
}


  
