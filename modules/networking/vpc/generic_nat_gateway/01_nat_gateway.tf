## -----------------------------------------------------------------------------
## Elastic ip and Nat Gateway
## -----------------------------------------------------------------------------
resource "aws_eip" "nat_gateway" {
  tags = {
    Name = "eip_${var.shortname}_nat_gateway_${var.public_subnet.az}"
  }
}

resource "aws_nat_gateway" "this" {
  depends_on = [aws_eip.nat_gateway]

  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = var.public_subnet.id

  tags = {
    Name = "natgw_${var.shortname}_${var.public_subnet.az}"
  }
}

## -----------------------------------------------------------------------------
## Router tables
## -----------------------------------------------------------------------------
resource "aws_route" "nat_gateway" {
  depends_on = [aws_nat_gateway.this]  

  route_table_id         = var.vpc.router_tables.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}