## --------------------------------------------------------------------------------------------------------------------
## Launch template instances policies and role.
## --------------------------------------------------------------------------------------------------------------------
## Policies
resource "aws_iam_policy" "codedeploy_vcp_endpoint" {
  name        = "CodeDeployVpcEndpoint-${var.shortname}"
  path        = "/TerraformManaged/"
  description = "Politica para EC2 usar VPC endpoint do agente do CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : [
          "codedeploy-commands-secure:GetDeploymentSpecification",
          "codedeploy-commands-secure:PollHostCommand",
          "codedeploy-commands-secure:PutHostCommandAcknowledgement",
          "codedeploy-commands-secure:PutHostCommandComplete"
        ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })

  tags = {
    Name = "CodeDeployVpcEndpoint-${var.shortname}"
  }
}

## Role
resource "aws_iam_role" "launch_tpl" {
  name = "role_launch_tpl_${var.shortname}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "role_launch_tpl_${var.shortname}"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_vcp_endpoint_to_launch_tpl" {
  policy_arn = aws_iam_policy.codedeploy_vcp_endpoint.arn
  role       = aws_iam_role.launch_tpl.name
}

# Necessária para download do build.zip no s3 durante o deploy.
resource "aws_iam_role_policy_attachment" "s3_read_to_launch_tpl" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.launch_tpl.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_to_launch_tpl" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # TODO - Verificar se ainda precisa.
  role       = aws_iam_role.launch_tpl.name
}

## Profile definition
resource "aws_iam_instance_profile" "launch_tpl" {
  name = "profile_launch_tpl_${var.shortname}"
  role = aws_iam_role.launch_tpl.name

  tags = {
    Name = "profile_launch_tpl_${var.shortname}"
  }
}
## --------------------------------------------------------------------------------------------------------------------
