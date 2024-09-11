module "data" {
  source = "../modules/data"
  requested_data = [
    "rds_app",
    "elb_app"
  ]
}