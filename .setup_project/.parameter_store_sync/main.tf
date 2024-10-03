## ---------------------------------------------------------------------------------------------------------------------
## Sincroniza os valores do Parameter Store com os valores do Github Secrets e Github Variables.
## ---------------------------------------------------------------------------------------------------------------------
module "parameter_store_sync" {
  source         = "../../infrastructure-modules/management/ssm/parameter_store_sync"
  shortname      = var.general_tag_shortname
  github_secrets = var.github_secrets
  github_vars    = var.github_vars
}
## ---------------------------------------------------------------------------------------------------------------------