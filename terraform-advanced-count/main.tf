# Create 3 resource groups with count

# Use length(var.xyz) , it will loop through list in terraform.tfvars to create resource accordingly
# Create a resource group
# var.rg_group_names is a list so we run count to get names on index 0,1,2
# Line  10 checks how many time to run this resource creatiom
# line 11-- loop thorugh list and get names

resource "azurerm_resource_group" "rg" {
    count   = length(var.rg_group_names)
    name     = var.rg_group_names[count.index]
    location = var.resource_group_location
}
