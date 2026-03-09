terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "~> 4.0"   # optional pin
    }
    azapi = {
      source = "Azure/azapi"
      # version = "~> 2.0"   # matches AVM peering requirement
    }
  }
}

variable "subscriptions" {
  type = map(string)
}

# Identity subscription (default)
provider "azurerm" {
  features {}
  use_oidc        = true
  subscription_id = var.subscriptions["identity"]
}

# Management subscription
provider "azurerm" {
  alias           = "management"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions["management"]
}

# Connectivity subscription
provider "azurerm" {
  alias           = "connectivity"
  features        {}
  use_oidc        = true
  subscription_id = var.subscriptions["connectivity"]
}

# AzAPI (used by AVM peering submodule)
provider "azapi" {
  use_oidc        = true
  subscription_id = var.subscriptions["identity"]
}
