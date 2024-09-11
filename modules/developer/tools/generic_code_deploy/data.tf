data "aws_s3_bucket" "project_bucket_name" {
  bucket = var.project_bucket_name
}

data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "github_app_connection" {
  name = var.codebuild_settings.github_connection_name
}

data "aws_ssm_parameter" "db_password" {
  name = "/github_secrets/${var.rds.ssm_parameter_db_password}"
}