output "application_name" {
  description = "Name of the Argo CD Application."
  value       = var.application_name
}

output "destination_namespace" {
  description = "Destination namespace of the Argo CD Application."
  value       = var.destination_namespace
}
