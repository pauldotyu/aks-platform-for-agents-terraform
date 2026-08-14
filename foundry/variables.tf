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

variable "model_format" {
  description = "The format of the model."
  type        = string
  default     = "OpenAI"
}

variable "model_name" {
  description = "The name of the model."
  type        = string
  default     = "gpt-5.4-mini"
}

variable "model_version" {
  description = "The version of the model."
  type        = string
  default     = "2026-03-17"
}

variable "model_sku_name" {
  description = "The SKU name of the model."
  type        = string
  default     = "GlobalStandard"
}

variable "model_sku_capacity" {
  description = "The SKU capacity of the model."
  type        = number
  default     = 200
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
