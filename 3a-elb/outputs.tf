output "elb" {
  description = "Load balancer"
  value       = module.elb.elb
}

output "target_groups" {
  description = "Blue/Green target groups"
  value       = module.elb.target_groups
}

output "lb_listeners" {
  description = "Listener"
  value       = module.elb.lb_listeners
}