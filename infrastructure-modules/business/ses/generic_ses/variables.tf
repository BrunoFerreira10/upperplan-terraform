variable "email_domain" {
  description = "O domínio que será utilizado para o SES"
  type        = string
}

variable "env" {
  description = "Ambiente onde a infraestrutura será criada."
  type        = string
  default     = "env"
}

variable "glpi_api_url" {
  description = "URL da API do GLPI"
  type        = string
}

variable "glpi_username" {
  description = "Usuário para autenticação na API do GLPI"
  type        = string
  sensitive   = true
}

variable "project_bucket" {
  description = "Bucket S3 onde serão armazenados os e-mails recebidos"
  type        = any
}

variable "region" {
  description = "Região onde os recursos serão provisionados"
  type        = string
}

variable "shortname" {
  description = "Nome curto para identificação dos recursos"
  type        = string
}
