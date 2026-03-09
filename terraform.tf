terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "cmltesttfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"

    use_oidc = true
  }
}
