module "logs_apache_access" {
  source            = "../modules/management/cloudwatch/generic_log_group"
  name              = "/ecs/apache-access"
  shortname         = module.data.github_vars.general_tag_shortname
  retention_in_days = 3
}

module "logs_apache_error" {
  source            = "../modules/management/cloudwatch/generic_log_group"
  name              = "/ecs/apache-error"
  shortname         = module.data.github_vars.general_tag_shortname
  retention_in_days = 3
}

module "logs_php_error" {
  source            = "../modules/management/cloudwatch/generic_log_group"
  name              = "/ecs/php-error"
  shortname         = module.data.github_vars.general_tag_shortname
  retention_in_days = 3
}
