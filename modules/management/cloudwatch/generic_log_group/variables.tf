variable "name" {
  description = "Log group name"
  type        = string
}

variable "retention_in_days" {
  description = "Retention in days for the log group"
  type        = number
  default     = 3
}

variable "shortname" {
  description = "Shortname for the log group"
  type        = string
}