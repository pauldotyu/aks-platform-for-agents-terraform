resource "azurerm_monitor_workspace" "example" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "metrics-${var.random_pet_name}"
}
