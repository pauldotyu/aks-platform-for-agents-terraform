resource "azurerm_cognitive_account" "example" {
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  name                  = "mf-${var.random_pet_name}"
  custom_subdomain_name = "mf-${var.random_pet_name}"
  kind                  = "AIServices"
  sku_name              = "S0"
  local_auth_enabled    = true
}

resource "azurerm_cognitive_deployment" "example" {
  cognitive_account_id = azurerm_cognitive_account.example.id
  name                 = var.model_deployment.model.name
  rai_policy_name      = "Microsoft.DefaultV2"

  model {
    format  = var.model_deployment.model.format
    name    = var.model_deployment.model.name
    version = var.model_deployment.model.version
  }

  sku {
    name     = var.model_deployment.sku.name
    capacity = var.model_deployment.sku.capacity
  }
}

resource "azurerm_user_assigned_identity" "example" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "mi-${var.random_pet_name}"
}

resource "azurerm_role_assignment" "spn" {
  principal_id         = azurerm_user_assigned_identity.example.principal_id
  role_definition_name = "Cognitive Services OpenAI User"
  scope                = azurerm_cognitive_account.example.id
}

resource "azurerm_federated_identity_credential" "example" {
  for_each                  = var.federated_identity_credentials
  user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  name                      = "fic-${each.key}"
  issuer                    = each.value.issuer_url
  audience                  = ["api://AzureADTokenExchange"]
  subject                   = "system:serviceaccount:${each.value.namespace}:${each.value.service_account}"
}

resource "azurerm_role_assignment" "users" {
  for_each             = var.model_user_principal_ids
  scope                = azurerm_cognitive_account.example.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = each.value
}
