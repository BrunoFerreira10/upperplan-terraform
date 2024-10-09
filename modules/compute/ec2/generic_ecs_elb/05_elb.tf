## ---------------------------------------------------------------------------------------------------------------------
## Application Load Balancer
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "this" {
  name               = replace("${var.env}-elb-${var.shortname}", "_", "-")
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    module.sg_elb.security_group.id
  ]
  subnets = [
    for subnet in var.vpc.subnets.public :
    subnet.id
  ]

  enable_deletion_protection = false

  idle_timeout = 3600

  tags = {
    Name = "${var.env}_elb_${var.shortname}"
  }
}

# Listener HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${var.env}_listener_http_${var.shortname}"
  }
}

# Listener HTTPS Blue
resource "aws_lb_listener" "https_blue" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  tags = {
    Name = "${var.env}_listener_https_blue_${var.shortname}"
  }
}

# Listener HTTPS Green
resource "aws_lb_listener" "https_green" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  tags = {
    Name = "${var.env}_listener_https_green_${var.shortname}"
  }
}

## ---------------------------------------------------------------------------------------------------------------------
