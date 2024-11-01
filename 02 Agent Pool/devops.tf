locals {
  org_service_url  = "https://dev.azure.com/${var.azure_devops_organization_name}"
  environment_name = "prod"
}

resource "azuredevops_agent_pool" "terraform" {
  name           = var.agent_pool_name
  auto_provision = false
  auto_update    = true
}
