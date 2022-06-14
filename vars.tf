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

variable "virtual_machine_names" {
    type = list(string)
    description = "List of all the Virtual machine names"
}

variable "vmdisks" {
    type = list(string)
    description = "List of all the Virtual machine names"
}

variable "jumpbox-public-ip" {
    description = "The jumbox public ip name"
    default = "jumpboxPublicIp"
}

variable "jumpboxVM" {
    description = "The jumbox Virtual machine names"
    default = "jumboxVM"
}
 
variable "vmudacity-nic" {
    type = list(string)
    description = "List of all the VM Nic names"
}
 
variable "jumpbox-nic" {
    description = "The jumbox Nic names"
    default = "jumpboxNetworkInterface"
}

variable "disks" {
    type = list(string)
    description = "List of all the BackEnd Address Pools names"
   
}

variable "natrules"{
   type = list(string)
   description = "list nat rule names"
}

variable "frontports" {
    type = list(string)
    description = "List of all the frontend ports names"
   
}


variable "BackEndAddressPool" {
    default = "BackEndAddressPool"
    description = "backend address pool name"
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      environment = "codelab"
   }
}

variable "vmudacity-nsg"{
   description = "Network security group "
   default = "vmUdacityNsg"
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}

variable "number" {
   description = "the number of resources create"
   default     = 3
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "Default password for admin account"
   default     = "azureuser"
}