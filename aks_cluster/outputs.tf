output "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azapi_resource.aks.id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azapi_resource.aks.name
}

output "aks_cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL of the AKS cluster."
  value       = azapi_resource.aks.output.properties.oidcIssuerProfile.issuerURL
}

output "aks_cluster_host" {
  description = "The Kubernetes API server endpoint for the AKS cluster."
  value       = local.kubeconfig.clusters[0].cluster.server
}

output "aks_cluster_ca_certificate" {
  description = "The base64-encoded Kubernetes cluster CA certificate."
  value       = local.kubeconfig.clusters[0].cluster["certificate-authority-data"]
  sensitive   = true
}

output "aks_cluster_client_certificate" {
  description = "The base64-encoded Kubernetes client certificate."
  value       = local.kubeconfig.users[0].user["client-certificate-data"]
  sensitive   = true
}

output "aks_cluster_client_key" {
  description = "The base64-encoded Kubernetes client key."
  value       = local.kubeconfig.users[0].user["client-key-data"]
  sensitive   = true
}

output "aks_cluster_kubeconfig" {
  description = "The base64-encoded cluster kubeconfig."
  value       = azapi_resource_action.get_aks_creds.output.kubeconfigs[0].value
  sensitive   = true
}
