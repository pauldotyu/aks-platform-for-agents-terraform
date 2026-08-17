variable "regions" {
  type = set(string)
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "subscription_id" {
  type      = string
  ephemeral = true
}

variable "client_id" {
  type      = string
  ephemeral = true
}

variable "tenant_id" {
  type      = string
  ephemeral = true
}

variable "admin_principal_ids" {
  description = "Object IDs of cluster administrators."
  type        = set(string)
  default     = []
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

variable "kubernetes_namespaces" {
  description = "A map of Kubernetes namespaces to be created in the AKS cluster."
  type = map(object({
    owner           = string
    users           = list(string)
    service_account = string
    adoption_policy = optional(string, "Always")
    delete_policy   = optional(string, "Delete")
    network_policy = optional(object({
      egress  = string
      ingress = string
      }), {
      egress  = "AllowAll"
      ingress = "AllowAll"
    })
    resource_quota = optional(object({
      cpuLimit      = string
      cpuRequest    = string
      memoryLimit   = string
      memoryRequest = string
      }), {
      cpuLimit      = "2000m"
      cpuRequest    = "2000m"
      memoryLimit   = "4096Mi"
      memoryRequest = "4096Mi"
    })
  }))
}

variable "argocd_apps" {
  description = "A map of Argo CD Applications to deploy in each regional AKS cluster."
  type = map(object({
    application_name      = string
    argocd_namespace      = optional(string, "argocd")
    project               = optional(string, "default")
    destination_namespace = string
    repo_url              = string
    chart                 = string
    target_version        = string
    values_object         = optional(string, "{}")
    create_namespace      = optional(bool, true)
  }))
  default = {}
}

variable "helm_releases" {
  description = "A map of Kubernetes applications to be deployed in the AKS cluster."
  type = map(object({
    chart            = string
    version          = optional(string)
    name             = string
    namespace        = string
    create_namespace = optional(bool, true)
    values           = optional(list(string), [])
    set = optional(list(object({
      name  = string
      value = string
      type  = optional(string)
    })), [])
    set_sensitive = optional(list(object({
      name  = string
      value = string
      type  = optional(string)
    })), [])
  }))
  default = {}
}
