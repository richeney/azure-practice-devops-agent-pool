variable "managed_identity_name" {
  type        = string
  description = "The name of the managed identity."
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


//================================================================

variable "azure_devops_organization_name" {
  type        = string
  description = "value of the Azure DevOps organization name"
}

variable "azure_devops_project_name" {
  type        = string
  description = "value of the Azure DevOps project name"
}

variable "azure_devops_personal_access_token" {
  type        = string
  description = "value of the Azure DevOps fine grained personal access token"
}

variable "azure_devops_variable_group_name" {
  type        = string
  description = "value of the Azure DevOps variable group name"
  default     = "Terraform Backend"

  validation {
    condition     = length(var.azure_devops_variable_group_name) > 0
    error_message = "The azure_devops_variable_group_name must be a valid string."
  }
}

variable "azure_devops_service_connection_name" {
  type        = string
  description = "value of the Azure DevOps service connection name"

  default = "Terraform"

  validation {
    condition     = length(var.azure_devops_service_connection_name) > 0
    error_message = "The service_connection_name must be a valid string."
  }
}

variable "azure_devops_create_pipeline" {
  description = "Create a pipeline in Azure DevOps."
  type        = bool
  default     = true
}

variable "azure_devops_create_files" {
  description = "Create a set of Terraform files in Azure DevOps."
  type        = bool
  default     = false
}

variable "azure_devops_self_hosted_agents" {
  description = "Boolean to determine if self-hosted agents should be used."
  type        = bool
  default     = false
}

# variable "azure_devops_agents_token" {
#   description = "Personal access token for Azure DevOps self-hosted agents (the token requires the 'Agent Pools - Read & Manage' scope and should have the maximum expiry)."
#   type        = string
#   sensitive   = true
#   default     = ""

#   validation {
#     condition     = length(var.azure_devops_agents_token) > 0
#     error_message = "The azure_devops_agents_token must be a valid string."
#   }
# }


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
