module "bastion" {
  source               = "../modules/compute/ec2/bastion"
  region               = module.data.github_vars.general_region
  ec2_ssh_keypair_name = module.data.github_vars.ec2_ssh_keypair_name
  vpc                  = module.data.projects.vpc_app.vpc
}
