variable "artifact_file_name" {
  description = "Artifact file name"
  type = string
  default = ""
}

variable "buildspec_file_name" {
  description = "Buildspec file name"
  type = string
}

variable "ecr_base_repository" {
  type = any
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

variable "project_name" {
  description = "Codebuild project name"
  type        = string  
}

variable "region" {
  description = "Região onde a infraestrutura será criada."
  type        = string
}

variable "repository_url_https" {
  type = string
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}