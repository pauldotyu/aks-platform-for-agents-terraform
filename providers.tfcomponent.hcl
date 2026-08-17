required_providers {
  azapi = {
    source  = "Azure/azapi"
    version = "~> 2.12"
  }

  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 5.1"
  }

  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "=3.2.1"
  }

  helm = {
    source  = "hashicorp/helm"
    version = "~> 3.2.0"
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

provider "kubernetes" "configurations" {
  for_each = length(var.argocd_apps) == 0 ? toset([]) : var.regions

  config {
    host                   = component.aks_cluster[each.key].aks_cluster_host
    cluster_ca_certificate = base64decode(component.aks_cluster[each.key].aks_cluster_ca_certificate)
    client_certificate     = base64decode(component.aks_cluster[each.key].aks_cluster_client_certificate)
    client_key             = base64decode(component.aks_cluster[each.key].aks_cluster_client_key)
  }

}

provider "helm" "configurations" {
  for_each = var.helm_releases == null ? toset([]) : var.regions

  config {
    kubernetes = {
      host                   = component.aks_cluster[each.key].aks_cluster_host
      cluster_ca_certificate = base64decode(component.aks_cluster[each.key].aks_cluster_ca_certificate)
      client_certificate     = base64decode(component.aks_cluster[each.key].aks_cluster_client_certificate)
      client_key             = base64decode(component.aks_cluster[each.key].aks_cluster_client_key)
    }
  }
}

provider "random" "this" {}
