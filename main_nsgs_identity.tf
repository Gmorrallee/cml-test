############################################
# Locals: build rules per NSG
############################################
locals {
  # Destination CIDR for each subnet (first/only prefix)
  subnet_dest = {
    uks = one(module.snet-dirservices-uks.address_prefixes)
    ukw = one(module.snet-dirservices-ukw.address_prefixes)
  }

  # Rule keys that should use destination "*"
  dest_any_rules = toset([
    "deny-all-any"
  ])

  # Base rules (no destination set here)
  nsg_rules_base = {
    "Bastion-Allow" = {
      name                    = "Bastion-Allow"
      access                  = "Allow"
      direction               = "Inbound"
      priority                = 100
      protocol                = "Tcp"

      source_address_prefixes = [
        "10.102.250.0/24",
        "10.103.250.0/24"
      ]
      source_port_range       = "*"

      destination_port_ranges = ["22", "3389"]
      # destination_address_prefix injected below
    }

    "DirServices-Allow" = {
      name                    = "DirServices-Allow"
      access                  = "Allow"
      direction               = "Inbound"
      priority                = 110
      protocol                = "*"
      source_address_prefix   ""VirtualNetwork"
      source_port_range       = "*"

      destination_port_ranges = ["53", "445"]
      # destination_address_prefix injected below
    }

    "deny-all-any" = {
      name                   = "Deny-Any-All"
      access                 = "Deny"
      direction              = "Inbound"
      priority               = 4000
      protocol               = "*"

      source_address_prefix  = "*"
      source_port_range      = "*"

      destination_port_range = "*"
      # destination_address_prefix injected below (and overridden to "*" via dest_any_rules)
    }
  }

  # Rules for UKS NSG: default destination subnet CIDR, override "*" for selected rules
  nsg_rules_dirservices_uks = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      { destination_address_prefix = local.subnet_dest.uks },
      contains(local.dest_any_rules, k) ? { destination_address_prefix = "*" } : {}
    )
  }

  # Rules for UKW NSG: default destination subnet CIDR, override "*" for selected rules
  nsg_rules_dirservices_ukw = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      { destination_address_prefix = local.subnet_dest.ukw },
      contains(local.dest_any_rules, k) ? { destination_address_prefix = "*" } : {}
    )
  }
}

############################################
# NSGs (AVM module)
############################################
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

############################################
# Associate NSGs to subnets
############################################
resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-uks" {
  subnet_id = module.snet-dirservices-uks.resource_id

  network_security_group_id = try(
    module.nsg-dirservices-uks.created_nsg_resource_id,
    module.nsg-dirservices-uks.resource_id,
    module.nsg-dirservices-uks.id
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-ukw" {
  subnet_id = module.snet-dirservices-ukw.resource_id

  network_security_group_id = try(
    module.nsg-dirservices-ukw.created_nsg_resource_id,
    module.nsg-dirservices-ukw.resource_id,
    module.nsg-dirservices-ukw.id
  )
}


  
