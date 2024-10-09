output "elb" {
  description = "Load balancer"
  value       = aws_lb.this
}

output "target_groups" {
  description = "Target groups"
  value = {
    blue  = aws_lb_target_group.blue
    green = aws_lb_target_group.green
  }
}

output "lb_listeners" {
  description = "Listener"
  value = {
    http        = aws_lb_listener.http,
    https_blue  = aws_lb_listener.https_blue,
    https_green = aws_lb_listener.https_green,
  }
}