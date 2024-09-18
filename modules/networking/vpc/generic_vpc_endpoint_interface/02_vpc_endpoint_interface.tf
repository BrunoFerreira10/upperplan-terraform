resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc.id
  # service_name      = "com.amazonaws.${var.region}.codedeploy-commands-secure"
  service_name      = "com.amazonaws.${var.region}.${var.service_name_sufix}"
  vpc_endpoint_type = "Interface"
  
  security_group_ids = [
    module.sg_vpc_endpoint_interface_rules.security_group.id
  ]

  subnet_ids = [
    for subnet in var.vpc.subnets.private 
    : subnet.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.shortname}_interface_${var.service_name_sufix}"
  }
}