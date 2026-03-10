locals {
  subnet_dest_management = {
    uks = one(module.snet-management-uks.address_prefixes)
    ukw = one(module.snet-management-ukw.address_prefixes)
  }

  nsg_rules_base_management = {
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

  rule_overrides_management_uks = {
    # keep deny catch-all as * destination in UKS
    "deny-all-any" = {
      destination_address_prefix = "*"
    }

  rule_overrides_management_ukw = {
    "deny-all-any" = {
      destination_address_prefix = "*"
    }

  nsg_rules_management_uks = {
    for k, v in local.nsg_rules_basemanagement :
    k => merge(
      v,
      lookup(local.rule_management_overrides_uks, k, {}),

      (
        try(lookup(local.rule_overrides_management_uks, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overrides_management_uks, k, {}).destination_address_prefixes, null) == null &&
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest_management.uks }
      : {}
    )
  }

  nsg_rules_management_ukw = {
    for k, v in local.nsg_rules_basemanagement :
    k => merge(
      v,
      lookup(local.rule_management_overrides_ukw, k, {}),

      (
        try(lookup(local.rule_management_overrides_ukw, k, {}).destination_address_prefix, null) == null &&
        try(lookup(local.rule_overridesmanagement__ukw, k, {}).destination_address_prefixes, null) == null &&
        try(v.destination_address_prefix, null) == null &&
        try(v.destination_address_prefixes, null) == null
      )
      ? { destination_address_prefix = local.subnet_dest_management.ukw }
      : {}
    )
  }
}

module "nsg-mgmt-management-uks" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"

  location            = var.location
  name                = "nsg-management-uks"
  resource_group_name = azurerm_resource_group.rg_management_networking.name

  security_rules      = local.nsg_rules_management_uks
}

module "nsg-dirservices-ukw" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.1"

  location            = var.location_2
  name                = "nsg-management-ukw"
  resource_group_name = azurerm_resource_group.rg_management_networking.name

  security_rules      = local.nsg_rules_management_ukw
}

############################################
# Associate NSGs to subnets
############################################
resource "azurerm_subnet_network_security_group_association" "nsg-management-uks" {
  subnet_id = module.snet-management-uks.resource_id

  network_security_group_id = try(
    module.nsg-management-uks.resource_id,
    module.nsg-management-uks.id,
    module.nsg-management-uks.created_nsg_resource_id
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg-management-ukw" {
  subnet_id = module.snet-management-ukw.resource_id

  network_security_group_id = try(
    module.nsg-management-ukw.resource_id,
    module.nsg-management-ukw.id,
    module.nsg-management-ukw.created_nsg_resource_id
  )
}
