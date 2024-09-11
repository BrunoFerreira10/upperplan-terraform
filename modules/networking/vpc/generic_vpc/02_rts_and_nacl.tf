## --------------------------------------------------------------------------------------------------------------------
## Router tables
## --------------------------------------------------------------------------------------------------------------------
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = "rt_default_app_${var.shortname}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "rt_public_app_${var.shortname}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route { # USER DATA
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "rt_private_app_${var.shortname}"
  }
}

## --------------------------------------------------------------------------------------------------------------------
## Network ACLs
## --------------------------------------------------------------------------------------------------------------------
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  tags = {
    Name = "nacl_default_app_${var.shortname}"
  }
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "nacl_public_app_${var.shortname}"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "nacl_private_app_${var.shortname}"
  }
}

## --------------------------------------------------------------------------------------------------------------------
## Create NACL rules dynamically
## --------------------------------------------------------------------------------------------------------------------
resource "aws_network_acl_rule" "public_ingress" {
  for_each = var.vpc_settings.nacl_rules.public.ingress

  network_acl_id = aws_network_acl.public.id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block != null ? each.value.cidr_block : aws_vpc.this.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}

resource "aws_network_acl_rule" "public_egress" {
  for_each = var.vpc_settings.nacl_rules.public.egress

  network_acl_id = aws_network_acl.public.id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block != null ? each.value.cidr_block : aws_vpc.this.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}

resource "aws_network_acl_rule" "private_ingress" {
  for_each = var.vpc_settings.nacl_rules.private.ingress

  network_acl_id = aws_network_acl.private.id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block != null ? each.value.cidr_block : aws_vpc.this.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}

resource "aws_network_acl_rule" "private_egress" {
  for_each = var.vpc_settings.nacl_rules.private.egress

  network_acl_id = aws_network_acl.private.id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block != null ? each.value.cidr_block : aws_vpc.this.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port != null ? each.value.from_port : each.value.port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port != null ? each.value.to_port : each.value.port
}