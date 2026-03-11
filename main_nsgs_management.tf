locals {
  # Grab the single CIDR from each subnet module (address_prefixes is a list)
  subnet_dest_management = {
    uks = one(module.snet_mgmt_management_uks.address_prefixes)
    ukw = one(module.snet_mgmt_management_ukw.address_prefixes)
  }

  # Base rule set used for both regions
  nsg_rules_base_management = {
    Bastion-Allow = {
      name      = "Bastion-Allow"
      access    = "Allow"
      direction = "Inbound"
      priority  = 100
      protocol  = "Tcp"

      source_address_prefixes = toset([
        "10.102.250.0/24",
        "10.103.250.0/24"
      ])
      source_port_range = "*"

      destination_port_ranges = toset(["22", "3389"])
      # destination_address_prefix gets injected automatically unless overridden
    }

    deny-all-any = {
      name      = "Deny-Any-All"
      access    = "Deny"
      direction = "Inbound"
      priority  = 4000
      protocol  = "*"

      source_address_prefix = "*"
      source_port_range     = "*"

      destination_port_range = "*"
      # We'll explicitly override destination to "*" below
    }
  }

  # Per-region overrides (only put things in here when you need them different)
  rule_overrides_management_uks = {
    deny-all-any = {
      destination_address_prefix = "*"
    }
  }

  rule_overrides_management_ukw = {
    deny-all-any = {
      destination_address_prefix = "*"
    }
  }

  # Helper: inject destination subnet CIDR only if:
  # - the base rule didn't set destination_address_prefix or destination_address_prefixes
  # - AND the override didn't set destination_address_prefix or destination_address_prefixes
  nsg_rules_management_uks = {
    for k, v in local.nsg_rules_base_management :
    k => merge(
      v,
      lookup(local.rule_overrides_management_uks, k, {}),
      (
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null &&
        try(lookup(local.rule_overrides_management_uks, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overrides_management_uks, k, {}).destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest_management.uks }
      : {}
    )
  }

  nsg_rules_management_ukw = {
    for k, v in local.nsg_rules_base_management :
    k => merge(
      v,
      lookup(local.rule_overrides_management_ukw, k, {}),
      (
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null &&
        try(lookup(local.rule_overrides_management_ukw, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overrides_management_ukw, k, {}).destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest_management.ukw }
      : {}
    )
  }
}

module "nsg_management_uks" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"
  
  providers = {
    azurerm = azurerm.management
  }

  location            = var.location
  name                = "nsg-management-uks"
  resource_group_name = azurerm_resource_group.rg_management_networking.name

  security_rules      = local.nsg_rules_management_uks
}

module "nsg_management_ukw" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"
  
  providers = {
    azurerm = azurerm.management
  }

  location            = var.location_2
  name                = "nsg-management-ukw"
  resource_group_name = azurerm_resource_group.rg_management_networking.name

  security_rules      = local.nsg_rules_management_ukw
}

############################################
# Associate NSGs to subnets
############################################
resource "azurerm_subnet_network_security_group_association" "nsg_management_uks" {
  subnet_id = module.snet_mgmt_management_uks.resource_id

  network_security_group_id = try(
    module.nsg_management_uks.resource_id,
    module.nsg_management_uks.id,
    module.nsg_management_uks.created_nsg_resource_id
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg_management_ukw" {
  subnet_id = module.snet_mgmt_management_ukw.resource_id

  network_security_group_id = try(
    module.nsg_management_ukw.resource_id,
    module.nsg_management_ukw.id,
    module.nsg_management_ukw.created_nsg_resource_id
  )
}
