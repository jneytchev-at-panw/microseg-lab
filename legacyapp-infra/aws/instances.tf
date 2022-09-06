# Bastion host, public IP
resource "aws_instance" "bst1" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = "${var.prefix}-ssh1"
  vpc_security_group_ids = [aws_security_group.bst-sg1.id,aws_security_group.default.id]
  subnet_id = aws_subnet.sn1.id
  associate_public_ip_address = true

  tags = {
    Name = "${var.prefix}-bst1"
    role = "Bastion"
  }
  ebs_optimized = true
  monitoring = true
}

# NAT instance for the private subnet
resource "aws_instance" "nat1" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
  key_name = "${var.prefix}-ssh1"

  network_interface {
    network_interface_id = aws_network_interface.nat1-eni1.id
    device_index = 0
  }
  user_data = <<EOT
#!/bin/bash
if [[ $(/usr/sbin/iptables -t nat -L) != *"MASQUERADE"* ]]; then
  /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/iptables -t nat -A POSTROUTING -s ${aws_vpc.vpc1.cidr_block} -j MASQUERADE
fi
  EOT

  tags = {
    Name = "${var.prefix}-nat1"
    role = "NAT"
  }
  ebs_optimized = true
  monitoring = true
}

resource "aws_network_interface" "nat1-eni1" {
  subnet_id = aws_subnet.sn1.id
  source_dest_check = false
  security_groups = [aws_security_group.default.id]

  tags = {
    Name = "${var.prefix}-nat1-eni1"
  }
}

# Elastic IP for the NAT instance
resource "aws_eip" "eip1" {
  network_interface = aws_network_interface.nat1-eni1.id
  vpc      = true
  depends_on = [aws_internet_gateway.igw1]

  tags = {
    Name = "${var.prefix}-eip1"
  }
}

# Private VMs for demos
resource "aws_instance" "vms1" {
  count = 3
  ami = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.medium"
  key_name = "${var.prefix}-ssh1"
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = aws_subnet.sn2.id
  associate_public_ip_address = false

  tags = {
    Name = "${var.prefix}-vm${count.index}"
  }
  ebs_optimized = true
  monitoring = true
}

# Lookup of the latest Amazon linux AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
