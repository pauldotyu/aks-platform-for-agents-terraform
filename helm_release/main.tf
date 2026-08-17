resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  chart            = var.chart
  version          = var.version
  values           = length(var.values) > 0 ? var.values : null
  set              = length(var.set) > 0 ? var.set : null
  set_sensitive    = length(var.set_sensitive) > 0 ? var.set_sensitive : null
}
