data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "github_app_connection" {
  name = var.github_connection_name
}

data "aws_s3_bucket" "project_bucket_name" {
  bucket = var.project_bucket_name
}