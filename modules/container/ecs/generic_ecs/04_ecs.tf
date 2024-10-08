## ---------------------------------------------------------------------------------------------------------------------
## ECS Task Definition
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "this" {

  family       = "${var.env}_task_${var.shortname}"
  track_latest = true

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    name = "glpi_config"
    efs_volume_configuration {
      file_system_id     = var.efs.id
      transit_encryption = "ENABLED"
    }
  }

  volume {
    name = "glpi_files"
    efs_volume_configuration {
      file_system_id     = var.efs.id
      transit_encryption = "ENABLED"
    }
  }

  volume {
    name = "glpi_logs"
    efs_volume_configuration {
      file_system_id     = var.efs.id
      transit_encryption = "ENABLED"
    }
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
      name              = "${var.env}_container_${var.shortname}"
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
      mountPoints = [
        {
          sourceVolume  = "glpi_config"
          containerPath = "/mnt/efs_glpi/config"
          readOnly      = false
        },
        {
          sourceVolume  = "glpi_files"
          containerPath = "/mnt/efs_glpi/files"
          readOnly      = false
        },
        {
          sourceVolume  = "glpi_logs"
          containerPath = "/mnt/efs_glpi/logs"
          readOnly      = false
        }
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
    Name = "${var.env}_task_${var.shortname}"
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Cluster
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "this" {
  name = "${var.env}_cluster_${var.shortname}"
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Service
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_service" "this" {
  name            = "${var.env}_service_${var.shortname}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn


  desired_count                      = var.aws_ecs_service_desired_count
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

  health_check_grace_period_seconds = 30

  # launch_type = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 2
  }

  # deployment_circuit_breaker {
  #   enable   = false
  #   rollback = false
  # }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.target_group.arn
    container_name   = "${var.env}_container_${var.shortname}"
    container_port   = 80
  }

  tags = {
    Name = "${var.env}_service_${var.shortname}"
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS Autoscaling
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 1
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "${var.env}_scaleby_memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 60
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.env}_scaleby_cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
## ---------------------------------------------------------------------------------------------------------------------
