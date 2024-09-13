module "logs" {
  source = "../../../management/cloudwatch/generic_log"
  name = "ecs_service"
  shortname = var.shortname
}