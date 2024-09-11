variable "app_repository_url_https" {
  type = string
}

variable "codebuild_settings" {
  description = "CodeBuild project settings"
  type = object({
    project_name = string
    github_connection_name = string
  })
}

variable "codedeploy_settings" {
  description = "CodeDeploy project settings"
  type = object({
    application_name = string
    target_group = any
    elb = any
    asg = any
  })
}

variable "domain" {
  description = "Domínio base da aplicação"
  type        = string
}

variable "project_bucket_name" {
  description = "Project bucket name"
  type = string
}

variable "rds" {
  description = "Application RDS"
  type        = any
}

variable "region" {
  description = "Região onde a infraestrutura está alocada"
  type = string
}

variable "shortname" {
  description = "Nome curto para identificação dos recursos na AWS"
  type        = string
}