resource "azurerm_public_ip" "pubip1" {
  name                = "${var.prefix}-pubip1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    owner = var.owner
  }
}

resource "azurerm_bastion_host" "bastion1" {
  name                = "${var.prefix}-bstn1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # To enable SSH connections from your machine:
  # 1. SKU must be Standard (not Basic)
  # 2. Check "Native client support" in bastion's configuration page.
  # 3. Run get_connect_bastion.sh to produce bastion connection commands.
  sku = "Standard"

  ip_configuration {
    name                 = "${var.prefix}-ipcfg1"
    subnet_id            = azurerm_subnet.bstn1.id
    public_ip_address_id = azurerm_public_ip.pubip1.id
  }

  tags = {
    owner = var.owner
  }
}