module "logs_tasks" {
  source    = "../../../management/cloudwatch/generic_log_group"
  env       = var.env
  name      = "/ecs/containers"
  shortname = var.shortname
}