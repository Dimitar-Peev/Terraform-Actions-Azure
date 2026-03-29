variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "sql_admin_login" {
  type        = string
  description = "SQL Server administrator username"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server administrator password"
  sensitive   = true
}

variable "sql_database_name" {
  type        = string
  description = "Name of the SQL Database"
}

variable "firewall_rule_name" {
  type        = string
  description = "Name of the firewall rule"
}

variable "dotnet_version" {
  type        = string
  description = "The .NET version for the Web App"
}

variable "github_repo_url" {
  type        = string
  description = "URL of the GitHub repository"
}

variable "github_branch" {
  type        = string
  description = "Branch to deploy from"
}

# variable "app_service_plan_name" {
#   type        = string
#   description = "Name of the App Service Plan"
# }

# variable "app_service_name" {
#   type        = string
#   description = "Name of the Linux Web App"
# }

# variable "sql_server_name" {
#   type        = string
#   description = "Name of the MSSQL Server"
# }
