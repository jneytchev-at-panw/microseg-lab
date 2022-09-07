# VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "${var.prefix}-vpc1"
  }
}

# Public subnet
resource "aws_subnet" "sn1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.10.0.0/20"

  tags = {
    Name = "${var.prefix}-sn1"
    type = "Public"
  }
}

# Private natted subnet
resource "aws_subnet" "sn2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.10.16.0/20"

  tags = {
    Name = "${var.prefix}-sn2"
    type = "Private, natted"
  }
}

# Route table for IGW, public subnet
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "${var.prefix}-rtb1"
  }
}

resource "aws_route_table_association" "rtb1as" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.rtb1.id
}

# Internet gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.prefix}-igw1"
  }
}

# Route table for private subnet, NAT gateway
resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_network_interface.nat1-eni1.id
  }
  tags = {
    Name = "${var.prefix}-rtb2"
  }
}

resource "aws_route_table_association" "rtb2as" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.rtb2.id
}


