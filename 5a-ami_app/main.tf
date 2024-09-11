module "ami_app" {
  source        = "../modules/compute/ec2_image_builder/generic_ami_builder"
  image_builder = module.data.projects.image_builder_app.image_builder
  shortname     = module.data.github_vars.general_tag_shortname

}
