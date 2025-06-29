# variables.tf (Root Level)
# Input variables for the entire infrastructure

variable "project_name" {
  description = "Name of the project - used for resource naming"
  type        = string
  default     = "nextjs-app"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets (costs ~$45/month per gateway)"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for cost optimization (reduces HA)"
  type        = bool
  default     = false
}

# Application Configuration
variable "container_port" {
  description = "Port on which the Next.js container listens"
  type        = number
  default     = 3000
}

variable "app_image" {
  description = "Docker image for the Next.js application"
  type        = string
  default     = "node:18-alpine"
}

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "domain_name" {
  default = "nextjs.codevitae.com"
  description = "Domain name for the CloudFront distribution (e.g., nextjs.codevitae.com)"
  type        = string
}

variable "root_domain" {
  description = "Root domain name (e.g., codevitae.com)"
  type        = string
}

variable "memory" {
  description = "Memory in MiB for the task"
  type        = number
  default     = 512

  validation {
    condition = (
      (var.cpu == 256 && contains([512, 1024, 2048], var.memory)) ||
      (var.cpu == 512 && contains([1024, 2048, 3072, 4096], var.memory)) ||
      (var.cpu == 1024 && contains([2048, 3072, 4096, 5120, 6144, 7168, 8192], var.memory)) ||
      (var.cpu == 2048 && var.memory >= 4096 && var.memory <= 16384 && var.memory % 1024 == 0) ||
      (var.cpu == 4096 && var.memory >= 8192 && var.memory <= 30720 && var.memory % 1024 == 0)
    )
    error_message = "Memory must be compatible with CPU selection. See AWS Fargate task size documentation."
  }
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}
