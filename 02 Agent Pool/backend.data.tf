data "azurerm_client_config" "current" {}

data "azurerm_subscription" "terraform" {
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "terraform" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "terraform" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.terraform.name
}