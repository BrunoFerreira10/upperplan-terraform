module "logs_tasks" {
  source    = "../../../management/cloudwatch/generic_log_group"
  name      = "/ecs/containers"
  shortname = var.shortname
}