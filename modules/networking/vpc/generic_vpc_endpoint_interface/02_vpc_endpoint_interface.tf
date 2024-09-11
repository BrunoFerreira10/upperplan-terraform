resource "aws_vpc_endpoint" "codedeploy" {
  vpc_id            = var.vpc.id
  service_name      = "com.amazonaws.${var.region}.codedeploy-commands-secure"
  vpc_endpoint_type = "Interface"
  
  security_group_ids = [
    module.sg_vpc_endpoint_codedeploy_rules.security_group.id
  ]

  subnet_ids = [
    for subnet in var.vpc.subnets.private 
    : subnet.id
  ]

  # dynamic subnet_configuration {
  #   for_each =  var.vpc.subnets.private
    
  #   content {
  #     subnet_id = subnet_configuration.value.id
  #   }
  # }

  private_dns_enabled = true

  tags = {
    Name = "codedeploy_${var.shortname}"
  }
}