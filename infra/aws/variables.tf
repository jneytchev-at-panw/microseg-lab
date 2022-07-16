variable "aws_profile" {
  default = "sso_power_user"
}

variable "aws_region" {
  default = ""
}

variable "prefix" {
  default = ""
}

variable "owner" {
  default = ""
}

# to get yours: whois $(curl ifconfig.co) | grep CIDR
variable "my_cidr" {
  default = ""
}
