provider "azurerm" {
  features {}
  use_oidc = true
}


provider "azurerm" {
  alias           = "management"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions.managment
}

provider "azurerm" {
  alias           = "connectivity"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions.connectivity
}

provider "azurerm" {
  alias           = "identity"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions.identity
}

