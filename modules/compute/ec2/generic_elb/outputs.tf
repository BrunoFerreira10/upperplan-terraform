output "asg" {
  description = "Auto-scaling group"
  value =  aws_autoscaling_group.this
}

output "elb" {
  description = "Load balancer"
  value =  aws_lb.this
}

output "target_group" {
  description = "Target group"
  value = aws_lb_target_group.this
}