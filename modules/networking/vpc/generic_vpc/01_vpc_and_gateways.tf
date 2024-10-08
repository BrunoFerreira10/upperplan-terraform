## -----------------------------------------------------------------------------
## VPC Definition 
## -----------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = "${var.vpc_settings.cidr_block}/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}_vpc_${var.shortname}"
  }
}


## Default security group deny all trafic 
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}_sg_default_app_${var.shortname}"
  }
}

## -----------------------------------------------------------------------------
## Internet Gateway
## -----------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}_igw_app_${var.shortname}"
  }
}