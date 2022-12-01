# Create 3 resource groups with count
# Check readme for details

# Use length(var.xyz) , it will loop through list in terraform.tfvars to create resource accordingly
# Create a resource group
# var.rg_group_names is a list so we run count to get names on index 0,1,2
# Line  10 checks how many time to run this resource creatiom
# line 11-- loop thorugh list and get names

# length, count, iterator loop

###uncomment
resource "azurerm_resource_group" "rg" {
    count   = length(var.rg_group_names)
    name     = var.rg_group_names[count.index]
    location = var.resource_group_location
}

# For-each loop
# Line 20, 21 sets loop
resource "azurerm_container_registry" "acr" {
  for_each = toset(var.acr_names)
  name     = each.value
  resource_group_name = azurerm_resource_group.rg[0].name
  location            = azurerm_resource_group.rg[0].location
  sku                 = "Basic"
  admin_enabled       = false
}

# If ELSE
# Terraform doesn’t support if-statements directly. However, you can accomplish the same thing by using the count parameter
# Terraform supports conditional expressions of the format <CONDITION> ? <TRUE_VAL> : <FALSE_VAL>.
# If you set count to 1 on a resource, you get one copy of that resource; 
# if you set count to 0, that resource is not created at all.
resource "azurerm_resource_group" "rg-test" {
    count = var.create_rg ? 1 : 0
    name     = "rg-test"
    location = var.resource_group_location
}
