identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

store "varset" "dev" {
  name     = "azure-dev"
  category = "env"
}

deployment "dev" {
  # destroy = true

  inputs = {
    identity_token = identity_token.azurerm.jwt

    prefix  = "dev"
    regions = ["westus3"]

    client_id       = store.varset.dev.ARM_CLIENT_ID
    subscription_id = store.varset.dev.ARM_SUBSCRIPTION_ID
    tenant_id       = store.varset.dev.ARM_TENANT_ID

    admin_principal_ids = ["ac06e8cd-0928-40aa-b8f2-6b4ac947ec4e"] # pauyu@microsoft.com

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
        users           = ["ac06e8cd-0928-40aa-b8f2-6b4ac947ec4e"] # pauyu@microsoft.com
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
}

store "varset" "test" {
  name     = "azure-test"
  category = "env"
}

deployment "test" {
  # destroy = true

  inputs = {
    identity_token = identity_token.azurerm.jwt

    prefix  = "test"
    regions = ["westus3"]

    client_id       = store.varset.test.ARM_CLIENT_ID
    subscription_id = store.varset.test.ARM_SUBSCRIPTION_ID
    tenant_id       = store.varset.test.ARM_TENANT_ID

    admin_principal_ids = ["ac06e8cd-0928-40aa-b8f2-6b4ac947ec4e"] # pauyu@microsoft.com

    model_deployment = {
      model = {
        format  = "OpenAI"
        name    = "gpt-5.4-mini"
        version = "2026-03-17"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 1000
      }
    }

    kubernetes_namespaces = {
      "demo" = {
        owner           = "team1"
        users           = ["ac06e8cd-0928-40aa-b8f2-6b4ac947ec4e"] # pauyu@microsoft.com
        service_account = "demo"
        network_policy = {
          egress  = "AllowAll"
          ingress = "AllowAll"
        }
        resource_quota = {
          cpuLimit      = "10000m"
          cpuRequest    = "4000m"
          memoryLimit   = "16384Mi"
          memoryRequest = "8192Mi"
        }
      }
    }

    argocd_apps = {
      sundae_funday = {
        application_name      = "sundae-funday"
        destination_namespace = "demo"
        repo_url              = "ghcr.io/pauldotyu/charts"
        chart                 = "sundae-funday"
        target_version        = ">=0.1.0-0 <0.2.0-0"
        create_namespace      = false

        values_object = <<-YAML
          config:
            OTEL_EXPORTER_OTLP_ENDPOINT: "$${otel_traces_endpoint}"
            OPENAI_BASE_URL: "$${foundry_openai_base_url}"
            OPENAI_CHAT_MODEL: "$${foundry_model_deployment_name}"
            OPENAI_AUTH_MODE: workload_identity
          secret:
            data:
              APPLICATIONINSIGHTS_CONNECTION_STRING: "$${application_insights_connection_string}"
          workloadIdentity:
            enabled: true
            clientId: "$${foundry_workload_identity_client_id}"
        YAML
      }
    }
  }
}
