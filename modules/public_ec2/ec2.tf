# example: amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "example-key"
  subnet_id                   = aws_subnet.lambda_layers_main_a.id
  ipv6_address_count          = 1
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.lambda_layers.id,
    aws_security_group.all_ping.id
  ]

  user_data = <<USER_DATA
#! /bin/bash
set -x
#download public keys from github
curl "https://github.com/${var.github_username}.keys" | tee -a /home/ec2-user/.ssh/authorized_keys
USER_DATA

  depends_on = [
    aws_internet_gateway.main_gw
  ]
}
