skip = coalesce(
  include.config.locals.skip,
  false
  )

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/security/acm.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}/security/acm//generic_acm"
}