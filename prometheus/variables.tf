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

variable "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  type        = string
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "azure_monitor_workspace_id" {
  description = "The ID of the Azure Monitor workspace."
  type        = string
}

variable "azure_monitor_workspace_name" {
  description = "The name of the Azure Monitor workspace."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace."
  type        = string
}