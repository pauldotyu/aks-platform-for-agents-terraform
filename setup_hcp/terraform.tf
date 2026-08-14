terraform {
  required_version = "1.15.8"

  cloud {
    organization = "yu-can-cloud"
    workspaces {
      name = "demo"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9"
    }
  }
}
