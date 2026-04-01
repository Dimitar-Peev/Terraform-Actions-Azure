terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

output "client_id" {
  value       = var.client_id
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