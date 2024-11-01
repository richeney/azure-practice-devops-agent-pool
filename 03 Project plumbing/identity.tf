resource "azurerm_storage_container" "terraform" {
  name                  = "tfstate"
  storage_account_name  = data.azurerm_storage_account.terraform.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "terraform" {
  name                = var.managed_identity_name
  resource_group_name = data.azurerm_resource_group.terraform.name
  location            = data.azurerm_resource_group.terraform.location
  tags                = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "contributor" {
  // Make this a default, but allow it to be overridden with an array of objects containing scope and role_definition_name
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}

resource "azurerm_role_assignment" "state" {
  scope                = "${data.azurerm_storage_account.terraform.id}/blobServices/default/containers/${azurerm_storage_container.terraform.name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}