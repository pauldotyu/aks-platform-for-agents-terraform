resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.application_name
      namespace = var.argocd_namespace
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = var.project
      source = {
        repoURL        = var.repo_url
        chart          = var.chart
        targetRevision = var.target_version
        helm = {
          releaseName  = var.application_name
          valuesObject = yamldecode(var.values_object)
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.destination_namespace
      }
      syncPolicy = merge(
        {
          automated = {
            prune    = true
            selfHeal = true
          }
        },
        var.create_namespace ? {
          syncOptions = ["CreateNamespace=true"]
        } : {},
      )
    }
  }
}
