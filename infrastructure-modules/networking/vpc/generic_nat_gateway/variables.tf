variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "public_subnet" {
  type        = any
  description = "Public subnet for NAT Gateway allocation."
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}