resource "random_pet" "group_name" {
  prefix = "demo"
  length = 1
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_pet.group_name.id}"
  location = var.region
}
