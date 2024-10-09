skip = coalesce(
  include.parameter_store.locals.skip, 
  include.config.locals.skip,
  false
)

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "parameter_store" {
  path   = "${dirname(find_in_parent_folders())}/_env/management/ssm/parameter_store.hcl"
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/management/ssm/parameter_store/save_parameter_rds_1_db_host.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}/management/ssm//generic_save_parameter"
}