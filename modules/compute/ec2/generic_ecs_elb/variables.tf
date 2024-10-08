## Required variables
variable "acm_certificate" {
  description = "ACM certificate for load balance HTTPS"
  type        = any
}

variable "app_repository_url" {
  description = "URL from app repository"
  type        = string
}

variable "domain" {
  description = "Domínio base da aplicação"
  type        = string
}

variable "env" {
  description = "Environment where the infrastructure will be created."
  type        = string
  default     = ""
}

variable "hosted_zone" {
  description = "Hosted zone ID for Route53"
  type        = string
}

variable "sg_elb_rules" {
  description = "Rules for ELB security group"
  type        = any
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}

variable "vpc" {
  description = "VPC for ELB allocation"
  type        = any
}