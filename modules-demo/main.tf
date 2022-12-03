# In Root main.tf we call resource group module
# Provide path to module in source key
module "module_RG" {
  source                  = "./modules/resource_group_module"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "acr" {
  source                  = "./modules/acr_rg"
  acr_resource_group_name     = module.module_RG.resource_group_name_id
  acr_resource_group_location = var.resource_group_location
  acr_name                =  var.acr_name
}