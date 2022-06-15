output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "bastion_public_ip_address" {
  value = azurerm_public_ip.pubip1.ip_address
}

output "vmss_id" {
    value = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "bastion_name" {
    value = azurerm_bastion_host.bastion1.name
}
