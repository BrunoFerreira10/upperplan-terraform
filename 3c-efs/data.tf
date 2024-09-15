## --------------------------------------------------------------------------------------------------------------------
## Retrieve all github vars (lowcase).
## Retrieve vpc_app information.
## --------------------------------------------------------------------------------------------------------------------
module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "vpc"
  ]
}