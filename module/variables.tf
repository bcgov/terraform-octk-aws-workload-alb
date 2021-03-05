variable "environment" {
  description = "The workload account environment (e.g. dev, test, prod)"
}

variable "name" {
  type        = string
  description = "ALB name"
}

variable "alb_cert_domain" {
  description = "The domain of cert to use for the internal ALB"
  default     = "*.example.ca"
  type        = string
}
