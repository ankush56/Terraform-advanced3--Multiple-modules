# Define variables here
variable "resource_group_location" {
    default = "eastus"
}

variable "resource_group_name" {
    default = "terraform-rg1"
}

variable "vnet_name" {
    default = "terraform-vnet1"
}

variable "nsg_name" {
    default = "inboundVMSSH"
}

variable "vm_name" {
    default = "terraform-vm"
}
