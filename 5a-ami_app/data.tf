module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "image_builder_app"
  ]
}