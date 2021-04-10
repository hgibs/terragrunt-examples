data "aws_availability_zones" "AZs" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_gw"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "10.0.1.0/24"
  #   gateway_id = aws_internet_gateway.main.id
  # }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main_gw.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.r.id
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
