locals {
  subnet_dest = {
    uks = one(module.snet-dirservices-uks.address_prefixes)
    ukw = one(module.snet-dirservices-ukw.address_prefixes)
  }

  nsg_rules_base = {
    "Bastion-Allow" = {
      name                    = "Bastion-Allow"
      access                  = "Allow"
      direction               = "Inbound"
      priority                = 100
      protocol                = "Tcp"

      source_address_prefixes = toset([
        "10.102.250.0/24",
        "10.103.250.0/24"
      ])
      source_port_range       = "*"

      destination_port_ranges = toset(["22", "3389"])
    }

    "DirServices-Allow" = {
      name                  = "DirServices-Allow"
      access                = "Allow"
      direction             = "Inbound"
      priority              = 110
      protocol              = "*"

      source_address_prefix = "VirtualNetwork"
      source_port_range     = "*"
      destination_port_ranges = toset(["53", "445"])

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

  rule_overrides_uks = {
    # keep deny catch-all as * destination in UKS
    "deny-all-any" = {
      destination_address_prefix = "*"
    }

    "DirServices-Allow" = {
      destination_address_prefixes = toset([
        "10.100.10.4"
      ])
    }
  }

  rule_overrides_ukw = {
    "deny-all-any" = {
      destination_address_prefix = "*"
    }

     "DirServices-Allow" = {
      destination_address_prefixes = toset([
        "10.200.10.4"
      ])
    }
  }

  nsg_rules_dirservices_uks = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      lookup(local.rule_overrides_uks, k, {}),

      (
        try(lookup(local.rule_overrides_uks, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overrides_uks, k, {}).destination_address_prefixes, null) == null &&
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest.uks }
      : {}
    )
  }

  nsg_rules_dirservices_ukw = {
    for k, v in local.nsg_rules_base :
    k => merge(
      v,
      lookup(local.rule_overrides_ukw, k, {}),

      (
        try(lookup(local.rule_overrides_ukw, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overrides_ukw, k, {}).destination_address_prefixes, null) == null &&
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest.ukw }
      : {}
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

############################################
# Associate NSGs to subnets
############################################
resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-uks" {
  subnet_id = module.snet-dirservices-uks.resource_id

  network_security_group_id = try(
    module.nsg-dirservices-uks.resource_id,
    module.nsg-dirservices-uks.id,
    module.nsg-dirservices-uks.created_nsg_resource_id
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg-dirservices-ukw" {
  subnet_id = module.snet-dirservices-ukw.resource_id

  network_security_group_id = try(
    module.nsg-dirservices-ukw.resource_id,
    module.nsg-dirservices-ukw.id,
    module.nsg-dirservices-ukw.created_nsg_resource_id
  )
}
