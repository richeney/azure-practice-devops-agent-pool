//================================================================
// These should be found in the backend.auto.tfvars file created by the bootstrap.sh script

variable "subscription_id" {
  type        = string
  description = "The subscription guid for the terraform resource group."

  validation {
    condition     = length(var.subscription_id) == 36 && can(regex("^[a-z0-9-]+$", var.subscription_id))
    error_message = "Subscription ID must be a 36 character GUID."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the (pre-existing) resource group to deploy resources."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account. Must be globally unique."

  validation {
    condition     = (length(coalesce(var.storage_account_name, "abcefghijklmnopqrstuwxy")) <= 24 && length(coalesce(var.storage_account_name, "ab")) > 3 && can(regex("^[a-z0-9]+$", coalesce(var.storage_account_name, "A%"))))
    error_message = "Storage account name must be null or 3-24 of lowercase alphanumerical characters, and globally unique"
  }
}

variable "container_name" {
  type        = string
  description = "The name of the storage container for the terraform state."
  default     = "agent-pool"

  validation {
    condition     = length(var.container_name) > 0
    error_message = "The container_name must be a valid string."
  }
}

variable "terraform_state_key" {
  type        = string
  description = "The key (or blob name) for the terraform state file in the storage container."
  default     = "terraform.tfstate"

  validation {
    condition     = length(var.terraform_state_key) > 0
    error_message = "The terraform_state_key must be a valid string."
  }
}
