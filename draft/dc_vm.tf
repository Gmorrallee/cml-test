module "vm_dc_uks" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.20"
  providers = { azurerm = azurerm }

  name                = "vm-dc-uks-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_identity_dirservices.name

  zone = "1" # required; set null if you’re in a region without zones [3](https://registry.terraform.io/modules/Azure/avm-res-compute-virtualmachine/azurerm/latest)[4](https://github.com/Azure/terraform-azurerm-avm-res-compute-virtualmachine/blob/main/variables.tf)

  account_credentials = {
    admin_credentials = {
      username                           = "localadmin"
      password                           = random_password.vm_admin.result
      generate_admin_password_or_ssh_key = false
    }
  }

  network_interfaces = {
    primary = {
      name = "nic-vm-dc-uks-01"
      ip_configurations = {
        primary = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.snet_idy_dirservices_uks.resource_id
        }
      }
    }
  }

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  managed_identities = { system_assigned = true }
}
