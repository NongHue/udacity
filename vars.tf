variable "packer_resource_group_name" {
   description = "Name of the resource group in which the Packer image will be created"
   default     = "myPackerImages"
}

variable "packer_image_name" {
   description = "Name of the Packer image"
   default     = "myPackerImage"
}

variable "resource_group_name" {
   description = "Name of the resource group in which the resources will be created"
   default     = "myResourceGroup"
}

variable "location" {
   default = "eastus"
   description = "Location where resources will be created"
}

variable virtual_machine_names {
    type = list(string)
    description = "List of all the Virtual machine names"
}

variable vmss-public-ips {
    type = list(string)
    description = "List of all the public Ip names"
}

variable jumpbox-public-ips {
    type = list(string)
    description = "List of all the jumbox public ip names"
}

variable jumpboxVM {
    type = list(string)
    description = "List of all the jumbox Virtual machine names"
}
 
variable jumpbox-nics {
    type = list(string)
    description = "List of all the jumbox Nic names"
}
variable BackEndAddressPools {
    type = list(string)
    description = "List of all the BackEnd Address Pools names"
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      environment = "codelab"
   }
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "Default password for admin account"
}