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
