resource "aws_key_pair" "ssh1" {
  key_name   = "${var.prefix}-ssh1"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    name = "${var.prefix}-ssh1"
  }
}