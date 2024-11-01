data "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.terraform.name
}


resource "azurerm_container_group" "alz" {
  for_each            = toset(["agent-01"])
  name                = each.value
  resource_group_name = data.azurerm_resource_group.terraform.name
  location            = data.azurerm_resource_group.terraform.location
  ip_address_type     = "Private"
  os_type             = "Linux"
  subnet_ids          = [azurerm_subnet.container_instances.id]


  image_registry_credential {
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
    server   = data.azurerm_container_registry.acr.login_server
  }

  // Included pipelines uses OIDC for authentication.
  // See <https://github.com/Azure-Samples/azure-devops-terraform-oidc-ci-cd/tree/main/pipelines>
  // for a comparison between OIDC and managed identity authentication.
  // OIDC is more secure and more flexible than managed identity authentication in this case.

  /*
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.terraform.id
    ]
  }
  */

  container {
    name   = each.value
    image  = "${data.azurerm_container_registry.acr.login_server}/azp-agent:linux"
    cpu    = 1
    memory = 4

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      AZP_AGENT_NAME = each.value
      AZP_URL        = local.org_service_url
      AZP_POOL       = var.agent_pool_name
    }

    secure_environment_variables = {
      AZP_TOKEN = var.azure_devops_agents_token
    }
  }
}
