output "otel_logs_endpoint" {
  description = "The endpoint for OpenTelemetry logs"
  value       = azapi_resource.otel.output.properties.OTLPLogsEndpoint
}

output "otel_metrics_endpoint" {
  description = "The endpoint for OpenTelemetry metrics"
  value       = azapi_resource.otel.output.properties.OTLPMetricsEndpoint
}

output "otel_traces_endpoint" {
  description = "The endpoint for OpenTelemetry traces"
  value       = azapi_resource.otel.output.properties.OTLPTracesEndpoint
}

output "application_insights_connection_string" {
  description = "The connection string for Application Insights"
  value       = azapi_resource.otel.output.properties.ConnectionString
  sensitive   = true
}

output "application_insights_resource_id" {
  description = "The resource ID of Application Insights"
  value       = azapi_resource.otel.id
}