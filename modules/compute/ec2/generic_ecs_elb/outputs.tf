output "elb" {
  description = "Load balancer"
  value =  aws_lb.this
}

output "target_groups" {
  description = "Target groups"
  value = {
    blue = aws_lb_target_group.blue
    green = aws_lb_target_group.green
  }
}