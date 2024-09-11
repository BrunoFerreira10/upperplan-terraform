variable "region" {
  type        = string
  description = "Região onde a infraestrutura será criada."
}

variable "shortname" {
  type        = string
  description = "Nome curto para identificacao dos recursos"
}

variable "vpc_settings" {
  description = "Configurações da VPC."
  type = object({
    nacl_rules = map(object({
      # ingress = map(any)
      ingress = map(object({
        rule_number = number
        protocol    = optional(string,"tcp")
        rule_action = optional(string,"allow")
        cidr_block  = optional(string)
        port        = optional(number)
        from_port   = optional(number)
        to_port     = optional(number)
      }))
      # egress = map(any)
      egress = map(object({
        rule_number = number
        protocol    = optional(string,"tcp")
        rule_action = optional(string,"allow")
        cidr_block  = optional(string)
        port        = optional(number)
        from_port   = optional(number)
        to_port     = optional(number)
      }))
    }))
  })
}
