variable "app_repository_url_https" {
  type = string
}

variable "env" {
  description = "Environment where the infrastructure will be created."
  type        = string
  default     = ""
}

variable "ecs" {
  description = "ECS Information"
  type        = any
}

variable "lb_listeners" {
  description = "Listeners for Blue/Green deployment"
  type        = any
}

variable "project_bucket" {
  type = any
}

variable "region" {
  description = "Região onde a infraestrutura será criada."
  type        = string
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}

variable "target_groups" {
  description = "Target groups for Blue/Green deployment"
  type        = any
}