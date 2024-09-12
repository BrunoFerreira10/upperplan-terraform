resource "aws_codebuild_source_credential" "this" {
  ## Possible values
  ## https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/import-source-credentials.html
  auth_type   = "CODECONNECTIONS"
  server_type = "GITHUB"
  token       = data.aws_codestarconnections_connection.github_app_connection.arn
}

resource "aws_codebuild_project" "ecr" {
  name          = "${var.shortname}-container-image-build"
  service_role  = aws_iam_role.codebuild.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  source {
    type            = "GITHUB"
    location        = var.app_repository_url_https
    git_clone_depth = 1
    buildspec       = templatefile("${path.module}/files/buildspec.yml.tpl", { 
      REGION = var.region,
      REPOSITORY_URI = aws_ecr_repository.this.repository_url
    })
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.shortname}-container-image-build"
    }
  }
}