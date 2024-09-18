## ---------------------------------------------------------------------------------------------------------------------
## ECS CodeDeploy - Deploy da imagem do container
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_codedeploy_app" "this" {
  name = "${var.shortname}-app"
  compute_platform = "ECS"

  tags = {
    Name        = "${var.shortname}-app"
  }
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.shortname}-app"
  service_role_arn       = aws_iam_role.codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs.cluster.name
    service_name = var.ecs.service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          var.lb_listeners.https_blue.arn
        ]
      }

      test_traffic_route {
        listener_arns = [
          var.lb_listeners.https_green.arn
        ]
      }

      target_group {
        name = var.target_groups.blue.name
      }

      target_group {
        name = var.target_groups.green.name
      }
    }
  }
}
## ---------------------------------------------------------------------------------------------------------------------