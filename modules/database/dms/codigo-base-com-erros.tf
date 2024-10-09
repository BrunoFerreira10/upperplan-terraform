# Criar VPC
resource "aws_vpc" "dms_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnets Públicas e Privadas
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.dms_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.dms_vpc.id
  cidr_block = "10.0.2.0/24"
}

# Customer Gateway (on-premises)
resource "aws_customer_gateway" "on_prem" {
  bgp_asn    = 65000
  ip_address = "YOUR_ONPREMISES_PUBLIC_IP"
  type       = "ipsec.1"
}

# VPN Gateway
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.dms_vpc.id
}

# VPN Connection
resource "aws_vpn_connection" "site_to_site" {
  customer_gateway_id = aws_customer_gateway.on_prem.id
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  type                = "ipsec.1"
}

# Definindo rotas VPN
resource "aws_vpn_connection_route" "route" {
  vpn_connection_id      = aws_vpn_connection.site_to_site.id
  destination_cidr_block = "10.0.2.0/24"
}

# Banco de Dados RDS
# resource "aws_db_instance" "rds" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   instance_class       = "db.t3.micro"
#   name                 = "dmsrds"
#   username             = "admin"
#   password             = "password"
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   db_subnet_group_name = aws_db_subnet_group.rds_subnets.id
# }

# Instância de replicação DMS
# resource "aws_dms_replication_instance" "dms_instance" {
#   replication_instance_class = "dms.t3.micro"
#   allocated_storage          = 100
#   publicly_accessible        = false
#   vpc_security_group_ids     = [aws_security_group.dms_sg.id]
#   replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnets.id
# }

# Security Group para RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.dms_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group para DMS
resource "aws_security_group" "dms_sg" {
  vpc_id = aws_vpc.dms_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
