data "azurerm_client_config" "current" {}

resource "azapi_resource" "aks" {
  type      = "Microsoft.ContainerService/managedClusters@2026-03-02-preview"
  parent_id = var.resource_group_id
  location  = var.resource_group_location
  name      = "aks-${var.random_pet_name}"

  // this required when azapi local schema check isn't aware of the latest api version
  schema_validation_enabled = false

  body = {
    identity = {
      type = "SystemAssigned"
    },
    properties = {
      dnsPrefix = "aks-${var.random_pet_name}"
      agentPoolProfiles = [
        {
          name       = "systempool"
          mode       = "System"
          count      = 3
          nodeTaints = ["CriticalAddonsOnly=true:NoSchedule"]
        }
      ]
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
      ingressProfile = {
        gatewayAPI = {
          installation = "Standard"
        }
        webAppRouting = {
          gatewayAPIImplementations = {
            appRoutingIstio = {
              mode = "Enabled"
            }
          }
        }
      }
      networkProfile = {
        networkPlugin     = "azure"
        networkPluginMode = "overlay"
        networkPolicy     = "cilium"
        networkDataplane  = "cilium"
        loadBalancerSku   = "Standard"
      }
      nodeProvisioningProfile = {
        defaultNodePools = "Auto"
        mode             = "Auto"
      }
      oidcIssuerProfile = {
        enabled = true
      }
      securityProfile = {
        workloadIdentity = {
          enabled = true
        }
      }
    }
    sku = {
      name = "Base"
      tier = "Standard"
    }
  }

  response_export_values = [
    "properties.oidcIssuerProfile.issuerURL",
    "properties.identityProfile.kubeletidentity.objectId"
  ]
}

resource "azurerm_kubernetes_cluster_extension" "argocd" {
  name           = "argocd"
  cluster_id     = azapi_resource.aks.id
  extension_type = "Microsoft.ArgoCD"
  release_train  = "Preview"
}

# another workaround for retrieving the kubeconfig, since the azurerm provider does not support it yet
resource "azapi_resource_action" "get_aks_creds" {
  type                   = azapi_resource.aks.type
  resource_id            = azapi_resource.aks.id
  action                 = "listClusterUserCredential"
  response_export_values = ["*"]
}

locals {
  kubeconfig = yamldecode(base64decode(azapi_resource_action.get_aks_creds.output.kubeconfigs[0].value))
}
