provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vmss" {
  name     = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

resource "azurerm_network_security_group" "vmss" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name
}

resource "azurerm_network_security_rule" "vmss" {
  name                        = "vmss-sernet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.2.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vmss.name
  network_security_group_name = azurerm_network_security_group.vmss.name
}

resource "azurerm_virtual_network" "vmss" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags = var.tags
}

resource "azurerm_subnet" "vmss" {
  name                 = "vmss-subnet"
  resource_group_name  = azurerm_resource_group.vmss.name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vmss" {
  count               = 3
  name                = var.vmss-public-ips[count.index]                       
  location                     = var.location
  resource_group_name          = azurerm_resource_group.vmss.name
  allocation_method            = "Static"
  tags = var.tags
}

resource "azurerm_lb" "vmss" {
  count = 3
  name                = "vmss-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss[count.index].id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  count = 3
  loadbalancer_id     = azurerm_lb.vmss[count.index].id
  name                = var.BackEndAddressPools[count.index]
}


resource "azurerm_lb_rule" "lbnatrule" {
  count = 3 
#  resource_group_name            = azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmss[count.index].id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb.vmss[count.index].id
}

resource "azurerm_availability_set" "vmss" {
  name                = "vmss-aset"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name

  tags = var.tags
}

data "azurerm_resource_group" "image" {
  name                = var.packer_resource_group_name
}

data "azurerm_image" "image" {
  name                = var.packer_image_name
  resource_group_name = data.azurerm_resource_group.image.name
}

data "azurerm_image" "image" {
  name                = var.packer_image_name
  resource_group_name = data.azurerm_resource_group.image.name
}

data "azurerm_managed_disk" "existing" {
  name                = "datadisk"
  resource_group_name = azurerm_resource_group.vmss.name
  lun          = 0
  caching        = "ReadWrite"
  create_option  = "Empty"
  disk_size_gb   = 10
}


resource "azurerm_virtual_machine_scale_set" "vmss" {
  count               = 3
  name                = var.virtual_machine_names[count.index]
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  upgrade_policy_mode = "Manual"
  
  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }
  

  storage_profile_image_reference {
    id=data.azurerm_image.image.id
  }

  
  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun          = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }
 
  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_user
    admin_password       = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.vmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool[count.index].id]
      primary = true
    }
  }
  
  tags = var.tags
}

resource "azurerm_public_ip" "jumpbox" {
  count                        = 3
  name                         = var.jumpbox-public-ips[count.index]
  location                     = var.location
  resource_group_name          = azurerm_resource_group.vmss.name
  allocation_method            = "Static"
  tags = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  count = 3
  name                = var.jumpbox-nics[count.index]
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = azurerm_subnet.vmss.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox[count.index].id
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "jumpbox" {
  count = 3
  name                  = var.jumpboxVM[count.index]
  location              = var.location
  resource_group_name   = azurerm_resource_group.vmss.name
  network_interface_ids = [azurerm_network_interface.jumpbox[count.index].id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }



  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  tags = var.tags
}