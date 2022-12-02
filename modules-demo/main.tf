# In Root main.tf we call resource group module
# Provide path to module in source key
module "module_RG" {
  source                  = "./modules/resource_group_module"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}