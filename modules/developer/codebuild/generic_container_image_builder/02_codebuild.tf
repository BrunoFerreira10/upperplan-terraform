## ---------------------------------------------------------------------------------------------------------------------
## Codeconnection - Conexão com o github
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_codebuild_source_credential" "this" {
  ## Possible values
  ## https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/import-source-credentials.html
  auth_type   = "CODECONNECTIONS"
  server_type = "GITHUB"
  token       = data.aws_codestarconnections_connection.github_app_connection.arn
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Codebuild - Build da imagem do container
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_codebuild_project" "ecr" {
  name         = "${var.shortname}-${var.project_name}"
  service_role = aws_iam_role.codebuild.arn

  # artifacts {
  #   type      = "S3"
  #   location  = var.project_bucket_name
  #   name      = "container-build.zip"
  #   path      = "code_build_outputs"
  #   packaging = "ZIP"
  # }

  artifacts {
    type = var.artifact_file_name != "" ? "S3" : "NO_ARTIFACTS"

    # Esses campos só são configurados quando type == "S3"
    location  = var.artifact_file_name != "" ? var.project_bucket_name : null
    name      = var.artifact_file_name != "" ? var.artifact_file_name : null
    path      = var.artifact_file_name != "" ? "code_build_outputs" : null
    packaging = var.artifact_file_name != "" ? "ZIP" : null
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type            = "GITHUB"
    location        = var.repository_url_https
    git_clone_depth = 1
    buildspec = templatefile("${path.module}/files/${var.buildspec_file_name}", {
      REGION              = var.region
      BASE_REPOSITORY_URI = var.ecr_base_repository.repository_url
      REPOSITORY_URI      = var.ecr_repository.repository_url
      SHORTNAME           = var.shortname
    })
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.shortname}-${var.project_name}"
    }
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## Webhooks - Qual evento no repositorio dispara o codebuild.
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_codebuild_webhook" "this" {
  project_name = "${var.shortname}-${var.project_name}"
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}

## ---------------------------------------------------------------------------------------------------------------------
