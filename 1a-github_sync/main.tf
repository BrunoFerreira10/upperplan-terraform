module "github_sync" {
  source         = "../modules/management/ssm/${var.shortname}/prod/github_sync"
  github_secrets = var.github_secrets
  github_vars    = var.github_vars
}