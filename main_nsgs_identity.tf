locals {
  # 1) Capture the destination CIDR for each subnet
  subnet_dest = {
    uks = one(module.snet-dirservices-uks.address_prefixes)
    ukw = one(module.snet-dirservices-ukw.address_prefixes)
  }

  # Rules that should keep destination "*"
  dest_any_rules = toset([
    "deny-all-any"
  ])

  # 2) Base rule template (no destination set here)
  nsg_rules_base = {
    "Bastion-Allow" = {
      name                    = "Bastion-Allow"
      access                  = "Allow"
      direction               = "Inbound"
      priority                = 100
      protocol                = "Tcp"
      source_address_prefixes = ["10.102.250.0/24", "10.103.250.0/24"]
      source_port_range       = "*"
      destination_port_ranges = ["22", "3389"]
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


  
