variable "email_domain" {
  description = "O domínio que será utilizado para o SES"
  type        = string
}

variable "glpi_api_url" {
  description = "URL da API do GLPI"
  type        = string
}

variable "glpi_app_token" {
  description = "Token da aplicação utilizado na API do GLPI"
  type        = string
}

variable "glpi_password" {
  description = "Senha para autenticação na API do GLPI"
  type        = string
  sensitive   = true
}

variable "glpi_username" {
  description = "Usuário para autenticação na API do GLPI"
  type        = string
  sensitive   = true
}

variable "project_bucket_name" {
  description = "Nome do bucket S3 onde serão armazenados os e-mails recebidos"
  type        = string
}

variable "region" {
  description = "Região onde os recursos serão provisionados"
  type        = string
}

variable "shortname" {
  description = "Nome curto para identificação dos recursos"
  type        = string
}
