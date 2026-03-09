terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "cmltesttfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"

    use_oidc  = true
    client_id = "6cfec517-1dcd-4183-98a3-3f60eeafdbd7"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
#      version = "~> 3.0"
    }
  }
}
