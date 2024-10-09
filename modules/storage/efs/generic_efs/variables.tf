variable "env" {
  description = "Ambiente onde a infraestrutura será criada."
  type        = string
  default     = ""  
}

variable "mount_target_subnets" {
  description = "Subnets where EFS need create mount points"
  type        = list(string)
}

variable "sg_efs_rules" {
  description = "Rules form RDS security group"
  type        = any
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}

variable "vpc" {
  description = "VPC for EFS allocations"
  type        = any
}