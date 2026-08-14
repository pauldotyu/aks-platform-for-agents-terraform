output "azure_monitor_workspace_name" {
  description = "The name of the Azure Monitor workspace."
  value       = azurerm_monitor_workspace.example.name
}

output "azure_monitor_workspace_id" {
  description = "The ID of the Azure Monitor workspace."
  value       = azurerm_monitor_workspace.example.id
}