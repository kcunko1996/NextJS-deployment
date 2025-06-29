variable "domain_name" {
  description = "Full domain name for the application"
  type        = string
  default     = "nextjs.codevitae.com"
}

variable "root_domain" {
  description = "Root domain name"
  type        = string
  default     = "codevitae.com"
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  type        = string
}