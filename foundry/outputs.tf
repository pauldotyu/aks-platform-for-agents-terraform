output "foundry_openai_base_url" {
  description = "The OpenAI v1 base URL for the Foundry account."
  value       = "https://${azurerm_cognitive_account.example.custom_subdomain_name}.services.ai.azure.com/openai/v1/"
}

output "foundry_model_deployment_name" {
  description = "The name of the deployed Foundry model."
  value       = azurerm_cognitive_deployment.example.name
}

output "foundry_account_id" {
  description = "The resource ID of the Foundry account."
  value       = azurerm_cognitive_account.example.id
}

output "foundry_workload_identity_id" {
  description = "The resource ID of the Foundry workload identity."
  value       = azurerm_user_assigned_identity.example.id
}

output "foundry_workload_identity_client_id" {
  description = "The client ID of the Foundry workload identity."
  value       = azurerm_user_assigned_identity.example.client_id
}

output "foundry_workload_identity_principal_id" {
  description = "The principal ID of the Foundry workload identity."
  value       = azurerm_user_assigned_identity.example.principal_id
}