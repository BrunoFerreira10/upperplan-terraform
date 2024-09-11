## --------------------------------------------------------------------------------------------------------------------
## Github Varibles - Only unsecure values
## --------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameters_by_path" "github_vars" {
  path            = "/github_vars"
  recursive       = true
  with_decryption = true
}

locals {
  names_split = [
    for name in data.aws_ssm_parameters_by_path.github_vars.names :
    split("/", substr(name, 1, -1))[1]
  ]

  github_vars = zipmap(
    local.names_split,
    data.aws_ssm_parameters_by_path.github_vars.values,
  )
}
## --------------------------------------------------------------------------------------------------------------------
## Projects remote states
## --------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "remote_states" {

  for_each = toset(var.requested_data)

  backend = "s3"
  config = {
    region = nonsensitive(local.github_vars.general_region)
    bucket = nonsensitive(local.github_vars.general_project_bucket_name)
    key    = "remote_states/${each.value}/terraform.tfstate"
  }
}

locals {
  projects = {
    for key, value in data.terraform_remote_state.remote_states :
    key => value.outputs
  }
}