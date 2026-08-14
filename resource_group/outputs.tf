output "resource_group_id" {
  description = "The ID of the resource group."
  value       = azurerm_resource_group.example.id
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = azurerm_resource_group.example.location
}

output "random_pet_name" {
  description = "The random pet name generated for the resources."
  value       = random_pet.group_name.id
}