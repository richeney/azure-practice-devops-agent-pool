output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "url_azure" {
  value = "https://portal.azure.com/#@${data.azurerm_subscription.terraform.tenant_id}/resource${data.azurerm_resource_group.terraform.id}"
}
