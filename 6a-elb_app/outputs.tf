output "asg" {
  description = "Auto-scaling group"
  value =  module.elb_app.asg
}

output "elb" {
  description = "Load balancer"
  value =  module.elb_app.elb
}

output "target_group" {
  description = "Target group"
  value = module.elb_app.target_group
}