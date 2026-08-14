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

variable "model_deployment" {
  description = "The model deployment"
  type = object({
    model = object({
      format  = string
      name    = string
      version = string
    })
    sku = object({
      name     = string
      capacity = number
    })
  })
}

variable "federated_identity_credentials" {
  description = "Federated identity credentials for the workload identity."
  type = map(object({
    namespace       = string
    service_account = string
    issuer_url      = string
  }))
}

variable "model_user_principal_ids" {
  description = "Object IDs of users who should have access to the model."
  type        = set(string)
  default     = []
}
