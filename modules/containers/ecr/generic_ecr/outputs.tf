output "repository" {
  value = aws_ecr_repository.this
}

output "policy" {
  value = aws_ecr_repository_policy.this
}