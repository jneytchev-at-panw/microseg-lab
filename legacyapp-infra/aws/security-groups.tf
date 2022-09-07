# Bastion host
resource "aws_security_group" "bst-sg1" {
  name        = "${var.prefix}-bst-sg1"
  description = "Allow SSH from my CIDR to bastion host"
  vpc_id      = aws_vpc.vpc1.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]
    description = "Allow SSH from the user"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow bastion to connect to the internet"
  }

  tags = {
    Name = "${var.prefix}-bst-sg1"
  }
}

# Default security group for VPC
resource "aws_security_group" "default" {
  name        = "${var.prefix}-default-sg1"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = [aws_vpc.vpc1.cidr_block]
    self      = true
    description = "Allow all ingress from within the VPC"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
    description = "Allow VMs to connect to the internet"
  }

  tags = {
    Name = "${var.prefix}-default-sg1"
  }
}
