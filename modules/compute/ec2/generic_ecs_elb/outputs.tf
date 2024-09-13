output "elb" {
  description = "Load balancer"
  value =  aws_lb.this
}

output "target_group" {
  description = "Target group"
  value = aws_lb_target_group.this
}