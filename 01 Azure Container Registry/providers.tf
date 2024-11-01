terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # backend.tf will be created by the bootstrap.sh script
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }

  storage_use_azuread = true

  resource_provider_registrations = "core"

  resource_providers_to_register = [
    "Microsoft.App",
    "Microsoft.AppConfiguration",
    "Microsoft.AppPlatform",
    "Microsoft.ContainerInstance",
    "Microsoft.ContainerRegistry",
    "Microsoft.ContainerService",
    "Microsoft.KeyVault",
    "Microsoft.Management",
    "Microsoft.ResourceGraph",
    "Microsoft.Security",
    "Microsoft.Sql",
    "Microsoft.Web"
  ]
}
