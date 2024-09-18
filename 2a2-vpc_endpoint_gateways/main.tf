## ---------------------------------------------------------------------------------------------------------------------
## VPC Endpoint Gateway - S3
## Dependentes
## - ECS Task Start - Faz o pull do ECR Registry que depende desse endpoint
## ---------------------------------------------------------------------------------------------------------------------
# module "s3_vpc_endpoint" {
#   source    = "../modules/networking/vpc/generic_vpc_endpoint_gateway"
#   region    = module.data.github_vars.general_region
#   shortname = module.data.github_vars.general_tag_shortname
#   vpc       = module.data.projects.vpc.vpc
# }
