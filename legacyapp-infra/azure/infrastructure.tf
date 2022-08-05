resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.resource_group_location

  tags = {
    owner = var.owner
  }
}

resource "azurerm_network_security_group" "sg1" {
  name                = "${var.prefix}-sg1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    owner = var.owner
  }
}

resource "azurerm_virtual_network" "vpc" {
  name                = "${var.prefix}-vpc1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]

  tags = {
    owner = var.owner
  }
}

resource "azurerm_subnet" "bstn1" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "sn1" {
  name                 = "${var.prefix}-sn1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "sn2" {
  name                 = "${var.prefix}-sn2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "snsg1" {
  subnet_id                 = azurerm_subnet.sn2.id
  network_security_group_id = azurerm_network_security_group.sg1.id
}

resource "azurerm_ssh_public_key" "ssh1" {
  name                = "${var.prefix}-ssh1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = file("~/.ssh/id_rsa.pub")

  tags = {
    owner = var.owner
  }
}


