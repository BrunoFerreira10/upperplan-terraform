variable "sg_vpc_endpoint_interface_rules" {
  description = "Rules for VPC Endpoint"
  type = any
}

variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "service_name_sufix" {
  type        = string
  description = "Nome do serviço que será acessado pelo VPC Endpoint."
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}