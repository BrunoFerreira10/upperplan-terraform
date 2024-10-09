## ---------------------------------------------------------------------------------------------------------------------
## Cross Account IAM Role - Role que permite a conta de origem assumir o papel na conta de destino
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "cross_account_role" {
  name = "Route53CrossAccountRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.origin_account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Política que permite acesso ao Route 53
resource "aws_iam_policy" "route53_policy" {
  name        = "Route53AccessPolicy"
  description = "Policy to allow access to Route 53 resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "route53:Get*",
        "route53:List*",
        "route53:ChangeResourceRecordSets"
      ]
      Resource = "*"
    }]
  })
}

# Anexar a política à role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.route53_policy.arn
}