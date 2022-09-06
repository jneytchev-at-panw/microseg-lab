resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "${var.prefix}-vmss1"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  sku                             = "Standard_DS1_v2"
  instances                       = 3
  admin_username                  = "ubuntu"
  disable_password_authentication = true

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 30
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "ubuntu"
    #public_key = var.my_public_key
    public_key = azurerm_ssh_public_key.ssh1.public_key
  }

  network_interface {
    name    = "${var.prefix}-nic1"
    primary = true

    ip_configuration {
      name      = "${var.prefix}-int1"
      subnet_id = azurerm_subnet.sn1.id
      primary   = true
    }
  }

  tags = {
    owner = var.owner
  }
  encryption_at_host_enabled = true
}