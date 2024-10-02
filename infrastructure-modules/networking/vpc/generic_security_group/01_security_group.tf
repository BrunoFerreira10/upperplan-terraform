locals {
  settings = var.security_group_settings
}

resource "aws_security_group" "this" {
  name        = "sg_${local.settings.id_name}_${var.shortname}"
  description = local.settings.description
  vpc_id      = var.vpc.id

  tags = {
    Name = "sg_${local.settings.id_name}_${var.shortname}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.security_group_settings.rules.ingress

  tags = {
    Name = each.value.description != null ? each.value.description : "Allow ${each.key}"
  }
  security_group_id = aws_security_group.this.id
  description       = each.value.description != null ? each.value.description : "Allow ${each.key}"
  cidr_ipv4         = each.value.cidr_ipv4 != null ? each.value.cidr_ipv4 : var.vpc.cidr_block
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.ip_protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port           = each.value.ip_protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.security_group_settings.rules.egress

  tags = {
    Name = each.value.description != null ? each.value.description : "Allow ${each.key}"
  }
  security_group_id = aws_security_group.this.id
  description       = each.value.description != null ? each.value.description : "Allow ${each.key}"
  cidr_ipv4         = each.value.cidr_ipv4 != null ? each.value.cidr_ipv4 : var.vpc.cidr_block
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.ip_protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port           = each.value.ip_protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}