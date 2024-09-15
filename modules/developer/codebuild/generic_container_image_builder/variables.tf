variable "app_repository_url_https" {
  type = string
}

variable "ecr_repository" {
  type = any
}

variable "github_connection_name" {
  type = string  
}

variable "project_bucket_name" {
  type = string  
}

variable "region" {
  description = "Região onde a infraestrutura será criada."
  type        = string
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}