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

# Чете съществуващия SP без да го създава
data "azuread_application" "app" {
  display_name = var.sp_name
}

data "azuread_service_principal" "sp" {
  client_id = data.azuread_application.app.client_id
}

data "azurerm_subscription" "current" {}

output "client_id" {
  value       = data.azuread_application.app.client_id
  description = "Client ID на Service Principal"
}

output "tenant_id" {
  value       = data.azurerm_subscription.current.tenant_id
  description = "Tenant ID"
}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "Subscription ID"
}

output "sp_object_id" {
  value       = data.azuread_service_principal.sp.object_id
  description = "Object ID на Service Principal"
}