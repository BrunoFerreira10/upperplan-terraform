resource "aws_instance" "bastion" {
  # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  ami = "ami-04b70fa74e45c3917"

  instance_type        = "t3.micro"
  key_name             = var.ec2_ssh_keypair_name
  subnet_id            = var.vpc.subnets.public.az_a.id
  iam_instance_profile = aws_iam_instance_profile.bastion.name

  vpc_security_group_ids = [
    module.sg_bastion.security_group.id
  ]

  user_data_replace_on_change = true
  user_data = templatefile(
    "${path.module}/scripts/userdata.tftpl", {
      REGION = "${var.region}"
    }
  )

  tags = {
    Name = "bastion_${var.vpc.name}"
  }
}