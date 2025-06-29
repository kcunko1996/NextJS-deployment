
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9._/-]+$", var.repository_name))
    error_message = "Repository name must contain only lowercase letters, numbers, dots, underscores, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to access this repository"
  type        = list(string)
  default     = []
}