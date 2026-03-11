resource "random_password" "vm_admin" {
  length  = 20
  special = true
}

module "vm_dc_uks" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.20"

  name                = "vm-dc-uks-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_identity_dirservices.name

  # Required in v0.20+:
  # If region has AZs, pick "1"/"2"/"3". If region has no AZs, set null.
  zone = "1"

  # Credentials are supplied via the v0.20 account_credentials interface
  account_credentials = {
    admin_credentials = {
      username = "localadmin"
      password = random_password.vm_admin.result
      # generate_admin_password_or_ssh_key defaults true, but we're providing password explicitly.
    }
  }

  network_interfaces = {
    primary = {
      name = "nic-vm-dc-uks-01"

      ip_configurations = {
        primary = {
          name                        = "ipconfig1"
          private_ip_subnet_resource_id = module.snet_mgmt_management_uks.resource_id
          # optional:
          # private_ip_address_allocation = "Dynamic"
          # is_primary_ipconfiguration    = true
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

  managed_identities = {
    system_assigned = true
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }
}
``

