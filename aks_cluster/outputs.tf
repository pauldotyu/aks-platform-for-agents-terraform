output "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_automatic_cluster.example.id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_automatic_cluster.example.name
}

output "aks_cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL of the AKS cluster."
  value       = azurerm_kubernetes_automatic_cluster.example.oidc_issuer_url
}
