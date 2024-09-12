data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "github_app_connection" {
  name = var.github_connection_name
}