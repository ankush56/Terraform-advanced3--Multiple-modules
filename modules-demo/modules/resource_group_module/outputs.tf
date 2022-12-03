output "resource_group_name" {
  # value = module.azurerm_resource_group.rg.name -> how we declare normally
  value = azurerm_resource_group.rg.name # output with modules
}

output "resource_group_name_id" {
  # value = module.azurerm_resource_group.rg.name -> how we declare normally
  value = azurerm_resource_group.rg.id # output with modules
}

output "resource_group_name_location" {
  # value = module.azurerm_resource_group.rg.name -> how we declare normally
  value = azurerm_resource_group.rg.location # output with modules
}