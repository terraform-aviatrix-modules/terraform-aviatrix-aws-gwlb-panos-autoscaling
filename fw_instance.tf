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

resource "aws_launch_template" "FWLaunchTemplate" {
  name                    = "FWLaunchTemplate"
  image_id                = data.aws_ami.panos_ami.id
  instance_type           = var.fw_instance_size
  key_name                = var.ssh_key_name
  ebs_optimized           = true
  disable_api_termination = true
  vpc_security_group_ids  = [aws_security_group.TrustSecurityGroup.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = iam_instance_profile.FirewallBootstrapInstanceProfile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    security_groups             = [aws_security_group.TrustSecurityGroup.id]
  }

  user_data = "vmseries-bootstrap-aws-s3bucket=\nmgmt-interface-swap=enable"
}


resource "aws_security_group" "TrustSecurityGroup" {
  name        = "TrustSecurityGroup"
  description = "Allow all"
  vpc_id      = var.aviatrix_vpc.vpc_id

  ingress {
    from_port        = 6081
    to_port          = 6081
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TrustSecurityGroup"
  }
}

