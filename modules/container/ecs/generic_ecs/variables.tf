variable aws_ecs_service_desired_count {
  description = "Desired count for ECS service"
  type        = number
}

variable "ecr_repository" {
  description = "ECR repository"
  type        = any
}

variable "efs" {
  description = "EFS that will be mounted on ECS service"
  type        = any
}

variable "env" {
  description = "Environment where the infrastructure will be created."
  type        = string
  default     = ""
}

variable "region" {
  description = "Região onde a infraestrutura será criada."
  type        = string
}

variable "sg_ecs_service_rules" {
  description = "Rules for ECS service security group"
  type        = any
}

variable "shortname" {
  description = "Nome curto para identificação dos recursos na AWS"
  type        = string
}

variable "target_group" {
  description = "Target group for ECS service"
  type        = any
}

variable "vpc" {
  description = "VPC that will allocate the bastion host security group"
  type        = any
}
