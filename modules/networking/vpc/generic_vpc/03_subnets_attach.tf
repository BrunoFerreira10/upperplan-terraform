locals {
  base_cidr_block = "${split(".", var.vpc_settings.cidr_block)[0]}.${split(".", var.vpc_settings.cidr_block)[1]}"
}

## --------------------------------------------------------------------------------------------------------------------
## Public subnet - AZ: a
## --------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public_az_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${local.base_cidr_block}.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}_subnet_public_az_a_app_${var.shortname}"
  }
}
resource "aws_route_table_association" "public_az_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_az_a.id
}
resource "aws_network_acl_association" "public_az_a" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_az_a.id
}

## --------------------------------------------------------------------------------------------------------------------
## Private subnet - AZ: a
## --------------------------------------------------------------------------------------------------------------------a
resource "aws_subnet" "private_az_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.base_cidr_block}.2.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.env}_subnet_private_az_a_app_${var.shortname}"
  }
}
resource "aws_route_table_association" "private_az_a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_az_a.id
}
resource "aws_network_acl_association" "private_az_a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_az_a.id
}

## --------------------------------------------------------------------------------------------------------------------
## Public subnet - AZ: b
## --------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public_az_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${local.base_cidr_block}.3.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}_subnet_public_az_b_app_${var.shortname}"
  }
}
resource "aws_route_table_association" "public_az_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_az_b.id
}
resource "aws_network_acl_association" "public_az_b" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_az_b.id
}

## --------------------------------------------------------------------------------------------------------------------
## Private subnet - AZ: b
## --------------------------------------------------------------------------------------------------------------------b
resource "aws_subnet" "private_az_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.base_cidr_block}.4.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.env}_subnet_private_az_b_app_${var.shortname}"
  }
}
resource "aws_route_table_association" "private_az_b" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_az_b.id
}
resource "aws_network_acl_association" "private_az_b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_az_b.id
}

## --------------------------------------------------------------------------------------------------------------------
## Public subnet - AZ: c
## --------------------------------------------------------------------------------------------------------------------
# resource "aws_subnet" "public_az_c" {
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = "${local.base_cidr_block}.5.0/24"
#   availability_zone       = "${var.region}c"
#   map_public_ip_on_launch = true


#   tags = {
#     Name = "${var.env}_subnet_public_az_c_app_${var.shortname}"
#   }
# }
# resource "aws_route_table_association" "public_az_c" {
#   route_table_id = aws_route_table.public.id
#   subnet_id      = aws_subnet.public_az_c.id
# }
# resource "aws_network_acl_association" "public_az_c" {
#   network_acl_id = aws_network_acl.public.id
#   subnet_id      = aws_subnet.public_az_c.id
# }

## --------------------------------------------------------------------------------------------------------------------
## Private subnet - AZ: c
## --------------------------------------------------------------------------------------------------------------------c
# resource "aws_subnet" "private_az_c" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "${local.base_cidr_block}.6.0/24"
#   availability_zone = "${var.region}c"

#   tags = {
#     Name = "${var.env}_subnet_private_az_c_app_${var.shortname}"
#   }
# }
# resource "aws_route_table_association" "private_az_c" {
#   route_table_id = aws_route_table.private.id
#   subnet_id      = aws_subnet.private_az_c.id
# }
# resource "aws_network_acl_association" "private_az_c" {
#   network_acl_id = aws_network_acl.private.id
#   subnet_id      = aws_subnet.private_az_c.id
# }