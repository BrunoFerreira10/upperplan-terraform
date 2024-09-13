output "repository" {
  value = aws_ecr_repository.this.name
}

output "policy" {
  value = aws_ecr_repository_policy.this.policy  
}