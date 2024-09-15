variable "region" {
  description = "Região onde a infraestrutura será criada."
  type        = string
}

variable "repository_name" {
  description = "Nome do repositório de imagens"
  type        = string
}

variable "shortname" {
  description = "Nome curto para identificação dos recursos na AWS"
  type        = string
}