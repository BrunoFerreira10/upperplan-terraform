skip = coalesce(
  include.logs.locals.skip, 
  include.config.locals.skip,
  false
)

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "logs"{
  path   = "${dirname(find_in_parent_folders())}/_env/management/cloudwatch/logs.hcl"
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/management/cloudwatch/logs/logs_apache_error.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}/management/cloudwatch//generic_log_group"
}