required_providers {
  azapi = {
    source  = "Azure/azapi"
    version = "~> 2.12"
  }
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 5.1"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.9"
  }
}

provider "azapi" "configurations" {
  for_each = var.regions

  config {
    use_oidc        = true
    oidc_token      = var.identity_token
    subscription_id = var.subscription_id
    client_id       = var.client_id
    tenant_id       = var.tenant_id
  }
}

provider "azurerm" "configurations" {
  for_each = var.regions

  config {
    features {
      resource_group {
        prevent_deletion_if_contains_resources = false
      }
    }

    environment     = "public"
    use_cli         = false
    use_oidc        = true
    oidc_token      = var.identity_token
    subscription_id = var.subscription_id
    client_id       = var.client_id
    tenant_id       = var.tenant_id
  }
}

provider "random" "this" {}
