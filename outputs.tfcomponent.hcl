output "otel_logs_endpoints" {
  description = "OpenTelemetry logs endpoint for each Azure region"
  type        = map(string)
  value = {
    for region, otel in component.otel : region => otel.otel_logs_endpoint
  }
}

output "otel_metrics_endpoints" {
  description = "OpenTelemetry metrics endpoint for each Azure region"
  type        = map(string)
  value = {
    for region, otel in component.otel : region => otel.otel_metrics_endpoint
  }
}

output "application_insights_connection_strings" {
  description = "Application Insights connection string for each Azure region"
  type        = map(string)
  value = {
    for region, otel in component.otel : region => otel.application_insights_connection_string
  }
  sensitive = true
}

output "application_insights_resource_ids" {
  description = "Application Insights resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, otel in component.otel : region => otel.application_insights_resource_id
  }
}

output "azure_monitor_workspace_ids" {
  description = "Azure Monitor workspace resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, monitor in component.monitor : region => monitor.azure_monitor_workspace_id
  }
}

output "log_analytics_workspace_ids" {
  description = "Log Analytics workspace resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, workspace in component.log_analytics : region => workspace.log_analytics_workspace_id
  }
}

output "aks_cluster_ids" {
  description = "AKS cluster resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, cluster in component.aks_cluster : region => cluster.aks_cluster_id
  }
}

output "aks_cluster_names" {
  description = "AKS cluster name for each Azure region"
  type        = map(string)
  value = {
    for region, cluster in component.aks_cluster : region => cluster.aks_cluster_name
  }
}

output "foundry_openai_base_urls" {
  description = "Foundry OpenAI v1 base URL for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_openai_base_url
  }
}

output "foundry_model_deployment_names" {
  description = "Foundry model deployment name for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_model_deployment_name
  }
}

output "foundry_account_ids" {
  description = "Foundry account resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_account_id
  }
}

output "foundry_workload_identity_ids" {
  description = "Foundry workload identity resource ID for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_workload_identity_id
  }
}

output "foundry_workload_identity_client_ids" {
  description = "Foundry workload identity client ID for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_workload_identity_client_id
  }
}

output "foundry_workload_identity_principal_ids" {
  description = "Foundry workload identity principal ID for each Azure region"
  type        = map(string)
  value = {
    for region, foundry in component.foundry : region => foundry.foundry_workload_identity_principal_id
  }
}
