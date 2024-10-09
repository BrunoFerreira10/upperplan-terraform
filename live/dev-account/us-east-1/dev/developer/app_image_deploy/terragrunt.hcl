skip = coalesce(
  include.config.locals.skip,
  false
  )

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/developer/app_image_deploy.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}/developer/codedeploy//generic_ecr_image_deploy"
}