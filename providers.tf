provider "azurerm" {
  features {}
  use_oidc        = true
  subscription_id = var.subscriptions["identity"]
}

provider "azurerm" {
  alias           = "management"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions["management"]
}

provider "azurerm" {
  alias           = "connectivity"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions["connectivity"]
}

# ✅ REQUIRED because AVM VNet module internally uses azapi
provider "azapi" {
  use_oidc        = true
  subscription_id = var.subscriptions["identity"]
}
