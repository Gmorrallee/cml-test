module "vm_dc_uks" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.20"

  name                = "vm-dc-uks-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_identity_dirservices.name

  os_type = "Windows"

  size = "Standard_D2s_v5"

resource "random_password" "vm_admin" {
  length  = 20
  special = true

resource "random_password" "vm_admin" {
  length  = 20
  special = true

  admin_username = "localadmin"
  admin_password = admin_password = random_password.vm_admin.result

  network_interfaces = {
    primary = {
      name      = "nic-vm-mgmt-uks-01"
      subnet_id = module.snet_mgmt_management_uks.resource_id
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

resource "random_password" "vm_admin" {
  length  = 20
  special = true


}

