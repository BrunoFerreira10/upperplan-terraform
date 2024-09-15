module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "vpc",
    "elb",
    "container_image_builder"
  ]
}