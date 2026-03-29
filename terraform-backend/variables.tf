variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for the backend"
}

variable "location" {
  type        = string
  description = "Location for all resources"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account (globally unique, lowercase, max 24 chars)"
}

variable "container_name" {
  type        = string
  description = "Name of the storage container"
}