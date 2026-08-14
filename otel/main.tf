resource "azapi_resource" "otel" {
  parent_id = var.resource_group_id
  location  = var.resource_group_location
  type      = "Microsoft.Insights/components@2025-01-23-preview"
  name      = "otel-${var.random_pet_name}"

  schema_validation_enabled = false

  body = {
    kind = "web"
    properties = {
      ApplicationId                      = "otel-${var.random_pet_name}"
      Application_Type                   = "web"
      Flow_Type                          = "Redfield"
      Request_Source                     = "IbizaAIExtension"
      IngestionMode                      = "LogAnalytics"
      WorkspaceResourceId                = var.log_analytics_workspace_id
      AzureMonitorWorkspaceResourceId    = var.azure_monitor_workspace_id
      AzureMonitorWorkspaceIngestionMode = "Enabled"
      publicNetworkAccessForIngestion    = "Enabled"
      publicNetworkAccessForQuery        = "Enabled"
    }
  }

  response_export_values = [
    "*"
  ]
}

