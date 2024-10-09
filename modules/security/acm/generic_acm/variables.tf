variable "acm_configuration" {
  description = "ACM Certificate configuration"
  type = object({
    domain     = string,
    hosted_zone = string,
    subdomains = optional(list(string), [])
  })
}

variable "env" {
  description = "Ambiente onde os recursos serao criados"
  type        = string
  default     = "env"
}

variable "shortname" {
  description = "Nome curto para identificacao dos recursos"
  type        = string
}