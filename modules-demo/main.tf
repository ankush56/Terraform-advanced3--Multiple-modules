# In Root main.tf we call resource group module
# Provide path to module in source key
module "module_RG" {
  source                  = "./modules/resource_group_module"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "acr" {
  source                  = "./modules/acr_rg"
  # For using output of another module...module being called must have output property field defined
  # For example, we called module.module_RG.resource_group_name_id this must be defined in output.tf of 
  # moduleRG
  acr_resource_group_name     = module.module_RG.resource_group_name
  acr_resource_group_location = module.module_RG.resource_group_name_location
  acr_name                =  var.acr_name
}

#Using Terraform registry module
module "network" {
  source  = "Azure/network/azurerm"
  version = "4.1.0"
  # insert the 1 required variable here
  resource_group_name = module.module_RG.resource_group_name #in output.tf
  #Adding optional inputs
  address_space = "10.0.0.0/23"
  subnet_names = ["subnet1", "subnet2"]
  subnet_prefixes = ["10.0.0.0/24", "10.0.1.128/25"]
}