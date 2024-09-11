variable "shortname" {
  type        = string
  description = "Nome curto para identificação dos recursos na AWS"
}

variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "project_bucket_name" {
  type        = string
  description = "Bucket name onde está o remote state"
}

variable "vpc" {
  type        = any
  description = "VPC for security group allocation."
}

variable "rds_configuration" {
  description = "RDS Configuration"
  type = object({
    db_name                   = string,
    db_username               = string,
    ssm_parameter_db_password = string,
    subnet_ids                = list(string),
    allocated_storage         = optional(number, 10),
    instance_class            = optional(string, "db.t3.micro"),
    publicly_accessible       = optional(bool, false),
    availability_zone         = optional(string, null)
  })
}

variable "sg_rds_rules" {
  description = "Rules form RDS security group"
  type = any
}
