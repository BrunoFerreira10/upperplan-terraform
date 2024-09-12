module "github_sync" {
  source         = "../modules/management/ssm/github_sync"
  shortname      = var.general_tag_shortname
  github_secrets = var.github_secrets
  github_vars    = var.github_vars
}