variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}