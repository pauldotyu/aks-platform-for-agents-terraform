variable "resource_group_id" {
  description = "The ID of the resource group."
  type        = string
}

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

variable "azure_monitor_workspace_id" {
  description = "The resource ID of the Azure Monitor workspace."
  type        = string
}

variable "grafana_admin_principal_ids" {
  description = "Object IDs of Grafana administrators that need access to the Grafana instance."
  type        = list(string)
  default     = []
}
