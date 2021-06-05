resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = var.aviatrix_vpc.vpc_id
  cidr_block = var.secondary_cidr
}

resource "aws_subnet" "LambdaMGMTSubnetAz1" {
  vpc_id            = var.aviatrix_vpc.vpc_id
  cidr_block        = local.lambda1_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"

  tags = {
    Name = "LambdaMGMTSubnetAz1"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]

}

resource "aws_subnet" "LambdaMGMTSubnetAz2" {
  vpc_id            = var.aviatrix_vpc.vpc_id
  cidr_block        = local.lambda2_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"

  tags = {
    Name = "LambdaMGMTSubnetAz2"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]

}

resource "aws_route_table" "LambdaMGMTRouteTable1" {
  vpc_id = var.aviatrix_vpc.vpc_id

  tags = {
    Name = "LambdaMGMTRouteTable1"
  }
}

resource "aws_route_table" "LambdaMGMTRouteTable2" {
  vpc_id = var.aviatrix_vpc.vpc_id

  tags = {
    Name = "LambdaMGMTRouteTable2"
  }
}

resource "aws_route_table_association" "LambdaMGMTSubnetRouteTableAssociation1" {
  subnet_id      = aws_subnet.LambdaMGMTSubnetAz1.id
  route_table_id = aws_route_table.LambdaMGMTRouteTable1.id
}

resource "aws_route_table_association" "LambdaMGMTSubnetRouteTableAssociation2" {
  subnet_id      = aws_subnet.LambdaMGMTSubnetAz2.id
  route_table_id = aws_route_table.LambdaMGMTRouteTable2.id
}

resource "aws_route" "LambdaMGMTRoute1" {
  route_table_id         = aws_route_table.LambdaMGMTRouteTable1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.Az1NatGW
}

resource "aws_route" "LambdaMGMTRoute2" {
  route_table_id         = aws_route_table.LambdaMGMTRouteTable2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.Az2NatGW
}

resource "aws_subnet" "TRUSTSubnetAz1" {
  vpc_id            = var.aviatrix_vpc.vpc_id
  cidr_block        = local.trust1_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"

  tags = {
    Name = "TRUSTSubnetAz1"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]

}

resource "aws_subnet" "TRUSTSubnetAz2" {
  vpc_id            = var.aviatrix_vpc.vpc_id
  cidr_block        = local.trust2_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"

  tags = {
    Name = "TRUSTSubnetAz2"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]

}

resource "aws_route_table" "TRUSTRouteTableAz1" {
  vpc_id = var.aviatrix_vpc.vpc_id

  tags = {
    Name = "TRUSTRouteTableAz1"
  }
}

resource "aws_route_table" "TRUSTRouteTableAz2" {
  vpc_id = var.aviatrix_vpc.vpc_id

  tags = {
    Name = "TRUSTRouteTableAz2"
  }
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociationNAT1" {
  subnet_id      = aws_subnet.TRUSTSubnetAz1.id
  route_table_id = aws_route_table.TRUSTRouteTableAz1.id
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociationNAT2" {
  subnet_id      = aws_subnet.TRUSTSubnetAz2.id
  route_table_id = aws_route_table.TRUSTRouteTableAz2.id
}

resource "aws_route" "TRUSTRouteNAT1" {
  route_table_id         = aws_route_table.TRUSTRouteTableAz1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.Az1NatGW
}

resource "aws_route" "TRUSTRouteNAT2" {
  route_table_id         = aws_route_table.TRUSTRouteTableAz2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.Az2NatGW
}

resource "aws_vpc_endpoint" "S3Endpoint1" {
  vpc_id       = var.aviatrix_vpc.vpc_id
  service_name = "com.amazonaws.${var.aviatrix_vpc.region}.s3"

  tags = {
    Environment = "S3Endpoint1"
  }
}

resource "aws_vpc_endpoint" "S3Endpoint2" {
  vpc_id       = var.aviatrix_vpc.vpc_id
  service_name = "com.amazonaws.${var.aviatrix_vpc.region}.s3"

  tags = {
    Environment = "S3Endpoint2"
  }
}

resource "aws_vpc_endpoint_route_table_association" "S3Endpoint1" {
  route_table_id  = aws_route_table.LambdaMGMTRouteTable1.id
  vpc_endpoint_id = aws_vpc_endpoint.S3Endpoint1.id
}

resource "aws_vpc_endpoint_route_table_association" "S3Endpoint2" {
  route_table_id  = aws_route_table.LambdaMGMTRouteTable2.id
  vpc_endpoint_id = aws_vpc_endpoint.S3Endpoint2.id
}

