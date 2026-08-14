variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "random_pet_name" {
  description = "The random pet name generated for the resources."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace."
  type        = string
}

variable "cluster_admin_principal_ids" {
  description = "Object IDs of cluster administrators."
  type        = set(string)
}
