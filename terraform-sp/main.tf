terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {}

data "azurerm_subscription" "current" {}

resource "azuread_application" "app" {
  display_name = var.sp_name
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

resource "azuread_service_principal_password" "sp_secret" {
  service_principal_id = azuread_service_principal.sp.id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

output "client_id" {
  value       = azuread_application.app.client_id
  description = "Client ID на Service Principal"
}

output "client_secret" {
  value       = azuread_service_principal_password.sp_secret.value
  sensitive   = true
  description = "Client Secret на Service Principal"
}

output "tenant_id" {
  value       = data.azurerm_subscription.current.tenant_id
  description = "Tenant ID"
}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "Subscription ID"
}
