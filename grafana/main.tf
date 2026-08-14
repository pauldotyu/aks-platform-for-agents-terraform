resource "azurerm_dashboard_grafana" "example" {
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  name                  = "grafana-${var.random_pet_name}"
  grafana_major_version = 13

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = var.azure_monitor_workspace_id
  }
}

resource "azurerm_role_assignment" "users" {
  for_each             = toset(var.grafana_admin_principal_ids)
  principal_id         = each.value
  scope                = azurerm_dashboard_grafana.example.id
  role_definition_name = "Grafana Admin"
}

resource "azurerm_role_assignment" "spn" {
  scope                = var.resource_group_id
  principal_id         = azurerm_dashboard_grafana.example.identity[0].principal_id
  role_definition_name = "Monitoring Data Reader"
}
