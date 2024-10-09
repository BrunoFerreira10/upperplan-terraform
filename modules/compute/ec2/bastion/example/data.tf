module "data" {
  source = "../modules/data"
  requested_data = [
    "vpc_app"
  ]
}