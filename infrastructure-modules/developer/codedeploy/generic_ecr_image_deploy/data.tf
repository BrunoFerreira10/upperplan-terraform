data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "project_bucket_name" {
  bucket = var.project_bucket_name
}