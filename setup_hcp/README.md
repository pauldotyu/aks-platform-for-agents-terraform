# HCP Terraform Azure bootstrap

> [!important]
> This HCP Terraform Stacks setup for Azure was taken from [https://github.com/hashicorp-education/learn-terraform-stacks-identity-tokens](https://github.com/hashicorp-education/learn-terraform-stacks-identity-tokens). Refer to the original repo for latest updates.

This directory creates the Microsoft Entra application, service principal, Azure role assignment, and federated identity credentials used by the HCP Terraform Stack.

## Setup

To execute this configuration you will need to give Terraform access to the relevant Azure account. Refer the [following](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) terraform provider docs to authenticate with Azure.

After applying the configuration, save these Terraform outputs:

1. `tenant_id` of the Azure AD/Microsoft Entra ID service.
2. `client_id` of the registered application created by this terraform setup.
3. `subscription_id` of your Azure account.

> [!WARNING]
> The bootstrap currently grants `Owner` at subscription scope so the Stack can create resources and role assignments. Review and reduce this access before using the configuration outside a development environment.

## Terraform Stacks

Once the above setup is complete, we can go ahead and proceed with running Terraform Stack operations.

```hcl
identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "dev" {
  inputs = {
    identity_token = identity_token.azurerm.jwt

    client_id       = "<Client ID from the setup>"
    subscription_id = "<Subscription ID from the setup>"
    tenant_id       = "<Tenant ID from the setup>"
  }
}
```

The bootstrap creates plan and apply credentials for the `dev`, `test`, and `production` deployment names. The root Stack currently defines only `dev`.

For more details, see the Azure Stacks example [guide](https://github.com/hashicorp-guides/azure-stacks-example).
