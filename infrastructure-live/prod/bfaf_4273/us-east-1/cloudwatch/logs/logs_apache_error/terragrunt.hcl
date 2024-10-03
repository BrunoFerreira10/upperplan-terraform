include {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

terraform {
  source    = "${include.locals.module_base_path}/management/cloudwatch//generic_log_group"
}

inputs = {
  env               = include.locals.env
  name              = "/ecs/apache_error"
  shortname         = include.locals.github_vars_mock.general_tag_shortname
  retention_in_days = 5
}