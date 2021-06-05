data "aws_ami" "panos_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.panos_image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"] # Palo Alto
}

data "aws_subnet" "Az1NatSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*gwlb-egress"]
  }
}

data "aws_subnet" "Az2NatSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*gwlb-egress"]
  }
}

data "aws_subnet" "Az1GWLBSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*gwlb-pool"]
  }
}

data "aws_subnet" "Az2GWLBSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*gwlb-pool"]
  }
}

data "aws_subnet" "Az1DMZFWSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az1}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*dmz-firewall"]
  }
}

data "aws_subnet" "Az2DMZFWSubnet" {
  availability_zone = "${var.aviatrix_vpc.region}${var.az2}"
  vpc_id            = var.aviatrix_vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*dmz-firewall"]
  }
}

data "aws_nat_gateway" "Az1NatGW" {
  subnet_id = data.aws_subnet.Az1NatSubnet.id
}

data "aws_nat_gateway" "Az2NatGW" {
  subnet_id = data.aws_subnet.Az2NatSubnet.id
}