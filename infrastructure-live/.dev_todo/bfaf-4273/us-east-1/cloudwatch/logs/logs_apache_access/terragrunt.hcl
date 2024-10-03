include {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

terraform {
  source    = "${include.root.locals.module_base_path}/management/cloudwatch//generic_log_group"
}

inputs = {
  env               = include.local.env
  name              = "/ecs/apache-access"
  shortname         = local.github_vars_mock.general_tag_shortname
  retention_in_days = 5
}