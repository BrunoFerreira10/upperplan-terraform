resource "aws_cloudwatch_metric_alarm" "cpu_bigger_than_limit" {
  alarm_name          = "cpu_bigger_than_limit_${var.shortname}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 10
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Uso da CPU maior que o limite."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [
    aws_autoscaling_policy.add_instance.arn
  ]

  tags = {
    Name = "cpu_bigger_than_limit_${var.shortname}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_lower_than_limit" {
  alarm_name          = "cpu_lower_than_limit_${var.shortname}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Uso da CPU menor que o limite."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [
    aws_autoscaling_policy.remove_instance.arn
  ]

  tags = {
    Name = "cpu_lower_than_limit_${var.shortname}"
  }
}
