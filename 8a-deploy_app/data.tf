module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "rds_app",
    "elb_app"
  ]
}