variable "allocated_storage" {
  description = "Armazenamento alocado em GB"
  type        = number
  default     = 10
}

variable "availability_zone" {
  description = "Zona de disponibilidade da instância RDS"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type        = string
}

variable "env" {
  description = "Ambiente onde a infraestrutura será criada."
  type        = string
  default     = "env"
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "publicly_accessible" {
  description = "Se a instância RDS é publicamente acessível"
  type        = bool
  default     = false
}

variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "sg_rds_rules" {
  description = "Rules for RDS security group"
  type        = any
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "ssm_parameter_db_password" {
  description = "Parâmetro SSM para a senha do banco de dados"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das sub-redes"
  type        = list(string)
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}