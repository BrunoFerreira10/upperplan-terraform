## ---------------------------------------------------------------------------------------------------------------------
## Target Groups
## ---------------------------------------------------------------------------------------------------------------------

# Target Group Azul
resource "aws_lb_target_group" "blue" {
  name     = replace("tg-blue-${var.shortname}", "_", "-")
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    interval            = 7
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-302"
  }

  tags = {
    Name = "tg-blue-${var.shortname}"
  }
}

# Target Group Verde
resource "aws_lb_target_group" "green" {
  name     = replace("tg-green-${var.shortname}", "_", "-")
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    interval            = 7
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-302"
  }

  tags = {
    Name = "tg-green-${var.shortname}"
  }
}
## ---------------------------------------------------------------------------------------------------------------------
