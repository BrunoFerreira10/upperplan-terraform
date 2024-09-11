resource "aws_codedeploy_app" "this" {
  name = "${var.codedeploy_settings.application_name}"

  tags = {
    Name        = "${var.codedeploy_settings.application_name}"
    # Environment = var.environment
  }
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.codedeploy_settings.application_name}"
  service_role_arn      = aws_iam_role.codedeploy.arn

  autoscaling_groups = [
    var.codedeploy_settings.asg.name
  ]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = var.codedeploy_settings.target_group.name
    }
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = "asg_${var.shortname}"
      type  = "KEY_AND_VALUE"
    }
  }

  # Opcional: Alarms Configuration
  # alarm_configuration {
  #   enabled                  = true
  #   alarms                   = ["my-cloudwatch-alarm-name"]
  #   ignore_poll_alarm_failure = false
  # }

  tags = {
    Name        = "${var.codedeploy_settings.application_name}"
    # Environment = var.environment
  }
}
