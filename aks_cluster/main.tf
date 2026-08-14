data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_automatic_cluster" "example" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "aks-${var.random_pet_name}"

  identity {
    type = "SystemAssigned"
  }

  web_app_routing_ingress {
    istio_enabled = true
  }
}

# temporary workaround for enabling monitoring
resource "azapi_update_resource" "aks" {
  type        = "Microsoft.ContainerService/managedClusters@2026-03-02-preview"
  resource_id = azurerm_kubernetes_automatic_cluster.example.id

  body = {
    properties = {
      addonProfiles = {
        omsagent = {
          enabled = true
          config = {
            logAnalyticsWorkspaceResourceID = var.log_analytics_workspace_id
            useAADAuth                      = "true"
          }
        }
      }
      azureMonitorProfile = {
        metrics = {
          enabled = true,
          kubeStateMetrics = {
            metricLabelsAllowlist      = "",
            metricAnnotationsAllowList = ""
          }
        }
        containerInsights = {
          logAnalyticsWorkspaceResourceId = var.log_analytics_workspace_id
          enabled                         = true,
        }
        appMonitoring = {
          autoInstrumentation = {
            enabled = true
          }
          openTelemetryLogsAndTraces = {
            enabled = true
          }
          openTelemetryMetrics = {
            enabled = true
          }
        }
      }
    }
  }
}

resource "azurerm_role_assignment" "example" {
  for_each             = var.cluster_admin_principal_ids
  principal_id         = each.value
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_automatic_cluster.example.id
}
