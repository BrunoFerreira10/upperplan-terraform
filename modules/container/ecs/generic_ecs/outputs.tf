output "ecs" {
  description = "ECS Service Information"
  value = {
    cluster = aws_ecs_cluster.this
    service = aws_ecs_service.this
  }
}