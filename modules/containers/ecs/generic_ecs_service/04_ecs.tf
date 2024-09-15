## ---------------------------------------------------------------------------------------------------------------------
## ECS Task Definition
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "this" {
  family = "task-${var.shortname}"
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      essential = true,
      image     = "${var.ecr_repository.repository_url}:latest",
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${module.logs_tasks.log_group.name}"
          awslogs-region        = "${var.region}"
          awslogs-stream-prefix = "ecs"
        }
      }
      name              = "container-${var.shortname}"
      cpu               = 1024,
      memory            = 2048,
      memoryReservation = 1024,
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        },
      ]
    }
  ])
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  task_role_arn      = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  memory = "2048"
  cpu    = "1024"

  tags = {
    Name = "task-${var.shortname}"
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Cluster
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "this" {
  name = "cluster-${var.shortname}"
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Service
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_service" "this" {
  name            = "service-${var.shortname}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn

  launch_type = "FARGATE"

  desired_count                      = 0
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets = [
      for subnet in var.vpc.subnets.private :
      subnet.id
    ]
    security_groups  = ["${module.sg_ecs.security_group.id}"]
    assign_public_ip = false
  }

  health_check_grace_period_seconds = 240

  # capacity_provider_strategy { 
  #   base              = 0
  #   capacity_provider = "FARGATE_SPOT"
  #   weight            = 100
  # }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.target_group.arn
    container_name   = "container-${var.shortname}"
    container_port   = 80
  }

  tags = {
    Name = "service-${var.shortname}"
  }

  # lifecycle {
  #   ignore_changes = [launch_type, task_definition, desired_count]
  # }

  # depends_on = [aws_lb_listener_rule.static]
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Autoscaling
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 3
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "scaleby-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "scaleby-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}
## ---------------------------------------------------------------------------------------------------------------------
