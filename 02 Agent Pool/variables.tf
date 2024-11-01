variable "container_registry_name" {
  type        = string
  description = "The name of the Azure Container Registry."
}

variable "agent_pool_name" {
  type        = string
  description = "The name of the Azure DevOps agent pool."
  default     = "agent-pool"

  validation {
    condition     = length(var.agent_pool_name) > 0
    error_message = "The agent_pool_name must be a valid string."
  }
}

variable "agent_pool_virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure DevOps agent pool."
  default     = "agent-pool-vnet"
}

variable "agent_pool_virtual_network_address_space" {
  type        = list(string)
  description = "The address space for the virtual network for the Azure DevOps agent pool."
  default     = ["10.0.0.0/24"]
}

//================================================================

variable "azure_devops_organization_name" {
  type        = string
  description = "value of the Azure DevOps organization name"
}

variable "azure_devops_personal_access_token" {
  type        = string
  description = "value of the Azure DevOps fine grained personal access token"
}

variable "azure_devops_agents_token" {
  description = "Personal access token for Azure DevOps self-hosted agents (the token requires the 'Agent Pools - Read & Manage' scope and should have the maximum expiry)."
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = length(var.azure_devops_agents_token) > 0
    error_message = "The azure_devops_agents_token must be a valid string."
  }
}


//================================================================

variable "location" {
  type        = string
  description = "The Azure region to deploy resources."
  default     = "UK South"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to resources."
  default     = null
}
