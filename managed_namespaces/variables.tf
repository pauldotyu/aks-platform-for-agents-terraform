variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  type        = string
}

variable "namespaces" {
  description = "A map of Kubernetes namespaces to be created in the AKS cluster."
  type = map(object({
    owner           = string
    users           = list(string)
    service_account = string
    adoption_policy = string
    delete_policy   = string
    network_policy = object({
      egress  = string
      ingress = string
    })
    resource_quota = object({
      cpuLimit      = string
      cpuRequest    = string
      memoryLimit   = string
      memoryRequest = string
    })
  }))
}
