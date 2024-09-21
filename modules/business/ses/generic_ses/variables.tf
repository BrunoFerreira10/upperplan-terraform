variable "email_domain" {
  description = "The domain to be used for the SES identity"
  type        = string
}

variable "project_bucket_name" {
  type        = string
  description = "Bucket name onde está o remote state"
}

variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}