skip = coalesce(
  include.config.locals.skip,
  false
  )

include "root"{
  path   = find_in_parent_folders()
  expose = true
}

include "repositories"{
  path   = "${dirname(find_in_parent_folders())}/_env/container/repositories.hcl"
  expose = true
}

include "config"{
  path   = "${dirname(find_in_parent_folders())}/_env/container/repositories/app_repository.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_path}/container/ecr//generic_ecr_repository"
}