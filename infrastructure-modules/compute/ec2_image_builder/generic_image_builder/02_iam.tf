## --------------------------------------------------------------------------------------------------------------------
## Image builder EC2 IAM definitions
## --------------------------------------------------------------------------------------------------------------------

## Policies

## TODO - Converter politicas gerenciadas pela AWS em custom.

## Role definition
resource "aws_iam_role" "img_builder_ec2" {
  name = "role_img_builder_ec2_${var.shortname}"

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
    Name = "role_img_builder_ec2_${var.shortname}"
  }
}

## Policies attachments
resource "aws_iam_role_policy_attachment" "default_to_img_builder_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
  role       = aws_iam_role.img_builder_ec2.name
}
resource "aws_iam_role_policy_attachment" "ssm_managed_to_img_builder_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.img_builder_ec2.name
}

## Profile definition
resource "aws_iam_instance_profile" "img_builder_ec2" {
  name = "profile_img_builder_ec2_${var.shortname}"
  role = aws_iam_role.img_builder_ec2.name

  tags = {
    Name = "profile_img_builder_ec2_${var.shortname}"
  }
}
## --------------------------------------------------------------------------------------------------------------------