terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate10494"
    container_name       = "tfstate"
    key                  = "terraform-sp.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azuread_application" "taskboard_app" {
  display_name = "taskboard-service-principal"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.taskboard_app.client_id
}

resource "azuread_service_principal_password" "sp_pwd" {
  service_principal_id = azuread_service_principal.sp.id
}

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "sp_role" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

output "new_client_id" {
  value = azuread_application.taskboard_app.client_id
}

output "new_client_secret" {
  value     = azuread_service_principal_password.sp_pwd.value
  sensitive = true
}

output "new_tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}