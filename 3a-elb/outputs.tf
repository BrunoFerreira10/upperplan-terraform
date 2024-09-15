output "elb" {
  description = "Load balancer"
  value =  module.elb_app.elb
}

output "target_groups" {
  description = "Blue/Green target groups"
  value = module.elb_app.target_groups
}

output "lb_listeners" {
  description = "Listener"
  value = module.elb_app.lb_listeners
}