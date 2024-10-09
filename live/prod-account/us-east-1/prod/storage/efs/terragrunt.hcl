skip = coalesce(
  include.config.locals.skip,
  false
  )

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/storage/efs.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}//storage/efs/generic_efs"
}