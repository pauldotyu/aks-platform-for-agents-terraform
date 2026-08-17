variable "chart" {
  description = "Full OCI URL of the Helm chart."
  type        = string

  validation {
    condition = (
      startswith(var.chart, "oci://") &&
      length(split("/", trimprefix(trimsuffix(var.chart, "/"), "oci://"))) >= 2
    )
    error_message = "chart must be a full OCI chart URL containing a registry path and chart name."
  }
}

variable "version" {
  description = "Helm chart version or OCI tag."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Helm release."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the Helm release."
  type        = string
}

variable "create_namespace" {
  description = "Whether Helm should create the release namespace."
  type        = bool
  default     = true
}

variable "values" {
  description = "YAML-formatted values passed to the Helm release."
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Values passed to the Helm release."
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "set_sensitive" {
  description = "Sensitive values to be merged with set values."
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}
