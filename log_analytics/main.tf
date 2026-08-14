resource "azurerm_log_analytics_workspace" "example" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "logs-${var.random_pet_name}"
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
