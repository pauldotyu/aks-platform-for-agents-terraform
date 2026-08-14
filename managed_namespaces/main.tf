// https://learn.microsoft.com/azure/templates/microsoft.containerservice/managedclusters/managednamespaces?pivots=deployment-language-terraform
resource "azapi_resource" "managed_namespace" {
  for_each = var.namespaces

  type      = "Microsoft.ContainerService/managedClusters/managedNamespaces@2026-03-02-preview"
  parent_id = var.aks_cluster_id
  location  = var.resource_group_location
  name      = each.key

  // this required when azapi local schema check isn't aware of the latest api version
  schema_validation_enabled = false

  body = {
    properties = {
      adoptionPolicy       = each.value.adoption_policy
      deletePolicy         = each.value.delete_policy
      defaultNetworkPolicy = each.value.network_policy
      defaultResourceQuota = each.value.resource_quota

      annotations = {
        project = each.key
        owner   = each.value.owner
      }

      labels = {
        "headlamp.dev/project-managed-by"    = "aks-desktop"
        "headlamp.dev/project-id"            = each.key
        "aks-desktop/project-subscription"   = split("/", var.aks_cluster_id)[2]
        "aks-desktop/project-resource-group" = var.resource_group_name
      }
    }
  }
}

resource "azurerm_role_assignment" "managed_namespace_user" {
  for_each = merge({}, [
    for namespace_key, namespace in var.namespaces : {
      for principal_id in toset(namespace.users) :
      "${namespace_key}:${principal_id}" => {
        namespace_key = namespace_key
        principal_id  = principal_id
      }
    }
  ]...)

  principal_id         = each.value.principal_id
  role_definition_name = "Azure Kubernetes Service Namespace User"
  scope                = azapi_resource.managed_namespace[each.value.namespace_key].id
}
