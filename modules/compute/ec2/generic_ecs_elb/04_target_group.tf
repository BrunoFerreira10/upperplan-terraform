resource "aws_lb_target_group" "this" {

  name     = replace("tg-ecs-${var.shortname}","_","-")
  port     = 80
  protocol = "HTTP"
  target_type = "ip"

  vpc_id   = var.vpc.id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600
  }

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = 80
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-404"
  }

  deregistration_delay = 15

  tags = {
    Name = "tg-ecs-${var.shortname}"
  }
}