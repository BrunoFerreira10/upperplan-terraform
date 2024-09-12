## -----------------------------------------------------------------------------
## Elastic ip and Nat Gateway
## -----------------------------------------------------------------------------
resource "aws_eip" "this" {
}

resource "aws_nat_gateway" "this" {
  depends_on = [aws_eip.nat_gateway]

  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet.id

  tags = {
    Name = "nat_${var.shortname}_${var.subnet.az}"
  }
}

## - Route --------------------------------------------------------------------
resource "aws_route" "nat_gateway" {
  route_table_id         = var.router_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this.id
}
## -----------------------------------------------------------------------------

