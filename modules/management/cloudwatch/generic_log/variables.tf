variable "name" {
  description = "Name of the log group"
  type        = string  
}

variable "retention_in_days" {
  description = "Retention in days for the log group"
  type        = number
  default     = 1
}

variable "shortname" {
  description = "Shortname for identification of resources in AWS"
  type        = string  
}