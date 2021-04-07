data "aws_vpc" "main" {
  id = var.main_vpc_id
}

data "aws_availability_zones" "AZs" {
  state = "available"
}

resource "aws_security_group" "lambda_layers" {
  name        = "lambda_layers_ssh"
  description = "Allow SSH inbound traffic for the layer builder"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH from home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_list # set your remote WAN IP here
  }

  egress {
    description      = "All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "lambda_layers_access"
  }
}

resource "aws_security_group" "all_ping" {
  name        = "all_ping"
  description = "Allow all ICMP"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "ICMPv4 from all"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "ICMPv6 from all"
    from_port        = -1
    to_port          = -1
    protocol         = "icmpv6"
    ipv6_cidr_blocks = ["::/0"]
    # cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "ICMPv4 egress all"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "ICMPv6 egress all"
    from_port        = -1
    to_port          = -1
    protocol         = "icmpv6"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow all ICMP"
  }
}

resource "aws_subnet" "lambda_layers_main_a" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 4, 1)
  map_public_ip_on_launch = true

  ipv6_cidr_block                 = cidrsubnet(data.aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  availability_zone = data.aws_availability_zones.AZs.names[0]

  tags = {
    Name = "example_a"
  }
}
