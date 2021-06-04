resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = var.aviatrix_vpc.vpc_id
  cidr_block = var.cidr
}

resource aws_subnet "LambdaMGMTSubnetAz1" {
  vpc_id = var.aviatrix_vpc.vpc_id
  cidr_block = local.lambda1_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"

  tags = {
    Name = "LambdaMGMTSubnetAz1"
  }
}

resource aws_subnet "LambdaMGMTSubnetAz2" {
  vpc_id = var.aviatrix_vpc.vpc_id
  cidr_block = local.lambda2_subnet
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"

  tags = {
    Name = "LambdaMGMTSubnetAz2"
  }
}