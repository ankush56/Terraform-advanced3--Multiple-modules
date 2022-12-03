# Define variables
variable "acr_resource_group_location" {
    default = "eastus"
}

variable "acr_resource_group_name" {
    default = "terraform-rg1"
}

variable "acr_name" {
    default = "acrmodule"
}