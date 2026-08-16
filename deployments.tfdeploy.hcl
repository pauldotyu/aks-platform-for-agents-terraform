identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

store "varset" "dev" {
  name     = "azure-dev"
  category = "env"
}

deployment "dev" {
  inputs = {
    identity_token = identity_token.azurerm.jwt

    regions = ["westus3"]

    client_id       = store.varset.dev.ARM_CLIENT_ID
    subscription_id = store.varset.dev.ARM_SUBSCRIPTION_ID
    tenant_id       = store.varset.dev.ARM_TENANT_ID

    admin_principal_ids = ["7002a869-11f9-4ac2-8cad-c16a09128b02"] # paul@yucancloud.com

    model_deployment = {
      model = {
        format  = "OpenAI"
        name    = "gpt-5.4-mini"
        version = "2026-03-17"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 500
      }
    }

    kubernetes_namespaces = {
      "demo" = {
        owner           = "team1"
        users           = ["4ccbb51c-654a-4239-b2ab-633aa2c0290f"] # pauyu@microsoft.com
        service_account = "demo"
        network_policy = {
          egress  = "AllowAll"
          ingress = "AllowAll"
        }
        resource_quota = {
          cpuLimit      = "5000m"
          cpuRequest    = "2000m"
          memoryLimit   = "8192Mi"
          memoryRequest = "4096Mi"
        }
      }
    }
  }
  
  destroy = true
}
