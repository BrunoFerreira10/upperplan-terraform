variable "shortname" {
  type = string
}

variable "requested_data" {
  description = "List of requested projects outputs"
  type        = list(string)
}