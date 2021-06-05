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

data "aws_nat_gateway" "Az1NatGW" {
  filter {
    name   = "name"
    values = ["${var.transit_gateway.gw_name}-gwlb-egress"]
  }
}

data "aws_nat_gateway" "Az2NatGW" {
  filter {
    name   = "name"
    values = ["${var.transit_gateway.gw_name}-hagw-gwlb-egress"]
  }
}