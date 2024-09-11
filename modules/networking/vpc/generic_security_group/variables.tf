variable "shortname" {
  type        = string
  description = "Nome curto para identificacao dos recursos"
}

variable "vpc" {
  description = "VPC for security group allocation."
  type        = any
}

variable "security_group_settings" {
  description = "Security group specific settings"
  type        = object({
    id_name     = string 
    description = optional(string, "")
    rules = object({
      ingress = map(object({
        description = optional(string)
        cidr_ipv4   = optional(string)
        ip_protocol = optional(string, "tcp")
        from_port   = optional(number)
        to_port     = optional(number)
        port        = optional(number)
      })),
      egress = map(object({
        description = optional(string)
        cidr_ipv4   = optional(string)
        ip_protocol = optional(string, "tcp")
        from_port   = optional(number)
        to_port     = optional(number)
        port        = optional(number)
      }))
    })
  })
}