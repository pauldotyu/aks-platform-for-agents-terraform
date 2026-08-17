variable "application_name" {
  description = "Name of the Argo CD Application and Helm release."
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace containing the Argo CD Application resource."
  type        = string
  default     = "argocd"
}

variable "project" {
  description = "Argo CD project assigned to the Application."
  type        = string
  default     = "default"
}

variable "destination_namespace" {
  description = "Kubernetes namespace where Argo CD deploys the Helm release."
  type        = string
}

variable "repo_url" {
  description = "Helm repository URL used by Argo CD."
  type        = string
}

variable "chart" {
  description = "Name of the Helm chart in the repository."
  type        = string
}

variable "target_version" {
  description = "Helm chart version assigned to spec.source.targetRevision."
  type        = string
}

variable "values_object" {
  description = "YAML-formatted Helm values decoded into spec.source.helm.valuesObject."
  type        = string
  default     = "{}"

  validation {
    condition     = can(keys(yamldecode(var.values_object)))
    error_message = "values_object must be YAML text whose root value is an object."
  }
}

variable "create_namespace" {
  description = "Whether Argo CD should create the destination namespace."
  type        = bool
  default     = true
}
