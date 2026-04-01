terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate10494"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {

  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  name                = "taskboard-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_mssql_server" "sql" {
  name                         = "taskboard-sql-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  name                 = var.sql_database_name
  server_id            = azurerm_mssql_server.sql.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  sku_name             = "Basic"
  zone_redundant       = false
  max_size_gb          = 2
  storage_account_type = "Local"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "azurerm_mssql_firewall_rule" "fw" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_linux_web_app" "app" {
  name                = "taskboard-app-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};User ID=${azurerm_mssql_server.sql.administrator_login};Password=${azurerm_mssql_server.sql.administrator_login_password};Trusted_Connection=False;MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "sc" {
  app_id                 = azurerm_linux_web_app.app.id
  repo_url               = var.github_repo_url
  branch                 = var.github_branch
  use_manual_integration = true
}
