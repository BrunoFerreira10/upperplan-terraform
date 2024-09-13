module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "vpc_app",
    "elb_app",
    "container_image_builder_app"
  ]
}