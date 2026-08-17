resource "random_pet" "group_name" {
  prefix = var.prefix
  length = 1
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_pet.group_name.id}"
  location = var.region
}
