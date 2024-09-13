module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "vpc_app",
    "acm_app",
    "rds_app",
    "efs_app"
  ]
}