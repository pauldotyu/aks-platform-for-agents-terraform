component "resource_group" {
  for_each = var.regions

  source = "./resource_group"

  inputs = {
    region = each.value
  }

  providers = {
    azurerm = provider.azurerm.configurations[each.value]
    random  = provider.random.this
  }
}

component "log_analytics" {
  for_each = var.regions

  source = "./log_analytics"

  inputs = {
    resource_group_name     = component.resource_group[each.value].resource_group_name
    resource_group_location = component.resource_group[each.value].resource_group_location
    random_pet_name         = component.resource_group[each.value].random_pet_name
  }

  providers = {
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "monitor" {
  for_each = var.regions

  source = "./monitor"

  inputs = {
    resource_group_name     = component.resource_group[each.value].resource_group_name
    resource_group_location = component.resource_group[each.value].resource_group_location
    random_pet_name         = component.resource_group[each.value].random_pet_name
  }

  providers = {
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "otel" {
  for_each = var.regions

  source = "./otel"

  inputs = {
    resource_group_id          = component.resource_group[each.value].resource_group_id
    resource_group_location    = component.resource_group[each.value].resource_group_location
    random_pet_name            = component.resource_group[each.value].random_pet_name
    log_analytics_workspace_id = component.log_analytics[each.value].log_analytics_workspace_id
    azure_monitor_workspace_id = component.monitor[each.value].azure_monitor_workspace_id
  }

  providers = {
    azapi   = provider.azapi.configurations[each.value]
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "grafana" {
  for_each = var.regions

  source = "./grafana"

  inputs = {
    resource_group_id           = component.resource_group[each.value].resource_group_id
    resource_group_name         = component.resource_group[each.value].resource_group_name
    resource_group_location     = component.resource_group[each.value].resource_group_location
    random_pet_name             = component.resource_group[each.value].random_pet_name
    azure_monitor_workspace_id  = component.monitor[each.value].azure_monitor_workspace_id
    grafana_admin_principal_ids = var.admin_principal_ids
  }

  providers = {
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "aks_cluster" {
  for_each = var.regions

  source = "./aks_cluster"

  inputs = {
    resource_group_id           = component.resource_group[each.value].resource_group_id
    resource_group_location     = component.resource_group[each.value].resource_group_location
    random_pet_name             = component.resource_group[each.value].random_pet_name
    log_analytics_workspace_id  = component.log_analytics[each.value].log_analytics_workspace_id
    cluster_admin_principal_ids = var.admin_principal_ids
  }

  providers = {
    azapi   = provider.azapi.configurations[each.value]
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "managed_namespaces" {
  for_each = var.regions

  source = "./managed_namespace"

  inputs = {
    aks_cluster_id          = component.aks_cluster[each.value].aks_cluster_id
    resource_group_name     = component.resource_group[each.value].resource_group_name
    resource_group_location = component.resource_group[each.value].resource_group_location
    namespaces              = var.kubernetes_namespaces
  }

  providers = {
    azapi   = provider.azapi.configurations[each.value]
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "prometheus" {
  for_each = var.regions

  source = "./prometheus"

  inputs = {
    resource_group_name          = component.resource_group[each.value].resource_group_name
    resource_group_location      = component.resource_group[each.value].resource_group_location
    random_pet_name              = component.resource_group[each.value].random_pet_name
    aks_cluster_id               = component.aks_cluster[each.value].aks_cluster_id
    aks_cluster_name             = component.aks_cluster[each.value].aks_cluster_name
    azure_monitor_workspace_id   = component.monitor[each.value].azure_monitor_workspace_id
    azure_monitor_workspace_name = component.monitor[each.value].azure_monitor_workspace_name
    log_analytics_workspace_id   = component.log_analytics[each.value].log_analytics_workspace_id
    log_analytics_workspace_name = component.log_analytics[each.value].log_analytics_workspace_name
  }

  providers = {
    azapi   = provider.azapi.configurations[each.value]
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "foundry" {
  for_each = var.regions

  source = "./foundry"

  inputs = {
    resource_group_name      = component.resource_group[each.value].resource_group_name
    resource_group_location  = component.resource_group[each.value].resource_group_location
    random_pet_name          = component.resource_group[each.value].random_pet_name
    model_user_principal_ids = var.admin_principal_ids
    model_deployment         = var.model_deployment

    federated_identity_credentials = {
      for namespace_key, namespace in var.kubernetes_namespaces :
      namespace_key => {
        namespace       = namespace_key
        service_account = namespace.service_account
        issuer_url      = component.aks_cluster[each.value].aks_cluster_oidc_issuer_url
      }
    }
  }

  providers = {
    azurerm = provider.azurerm.configurations[each.value]
  }
}

component "argocd_app" {
  for_each = {
    for pair in setproduct(var.regions, keys(var.argocd_apps)) :
    "${pair[0]}:${pair[1]}" => {
      region = pair[0]
      app    = var.argocd_apps[pair[1]]
    }
  }

  source = "./argocd_app"

  inputs = {
    application_name      = each.value.app.application_name
    argocd_namespace      = each.value.app.argocd_namespace
    project               = each.value.app.project
    destination_namespace = each.value.app.destination_namespace
    repo_url              = each.value.app.repo_url
    chart                 = each.value.app.chart
    target_version        = each.value.app.target_version
    values_object = templatestring(each.value.app.values_object, {
      application_name                       = each.value.app.application_name
      destination_namespace                  = each.value.app.destination_namespace
      otel_logs_endpoint                     = component.otel[each.value.region].otel_logs_endpoint
      otel_metrics_endpoint                  = component.otel[each.value.region].otel_metrics_endpoint
      otel_traces_endpoint                   = component.otel[each.value.region].otel_traces_endpoint
      application_insights_connection_string = component.otel[each.value.region].application_insights_connection_string
      foundry_openai_base_url                = component.foundry[each.value.region].foundry_openai_base_url
      foundry_model_deployment_name          = component.foundry[each.value.region].foundry_model_deployment_name
      foundry_workload_identity_client_id    = component.foundry[each.value.region].foundry_workload_identity_client_id
    })
    create_namespace = each.value.app.create_namespace
  }

  providers = {
    kubernetes = provider.kubernetes.configurations[each.value.region]
  }
}
