variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "router_table" {
  type        = any
  description = "Route table for NAT Gateway allocation."
}

variable "subnets" {
  type        = map(any)
  description = "Subnet for NAT Gateway allocation."  
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}