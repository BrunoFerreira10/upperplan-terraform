skip = coalesce(
  include.config.locals.skip,
  false
  )

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/database/rds.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}//database/rds/generic_mysql"
}