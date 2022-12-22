### Few ways to create random name
#random_id
#random_pet
#random_shuffle
#random_string

# Create random string - This will create a random character string to be used for naming of resources
# random_string.name*.result gives output of random number
resource "random_string" "random_rg" {
  length  = 4
  special = false
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}-${random_string.random_rg.result}" 
  location = var.resource_group_location
}