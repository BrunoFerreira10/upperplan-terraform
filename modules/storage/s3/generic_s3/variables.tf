variable "bucket_name" {
  type        = string
  description = "Bucket name"
  
}

variable "force_destroy" {
  type = bool
  description = "Value to force destroy the bucket"
  default = false
}