terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}

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

# 🔴 THIS IS THE BIT YOU ARE MISSING
provider "azapi" {
  use_oidc        = true
  subscription_id = var.subscriptions["identity"]
}
