output "bastion_ip" {
    description = "Public IP address of the bastion instance."
    value = aws_instance.bst1.public_ip
}

output "nat_ip" {
    description = "Private IP address of the NAT instances"
    value = aws_instance.nat1.private_ip
}

output "demo_vm_ips" {
    description = "Private IP addresses of all demo VMs."
    value = join(" ", aws_instance.vms1[*].private_ip)
}
