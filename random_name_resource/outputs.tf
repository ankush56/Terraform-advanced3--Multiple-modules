output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "random_name_string" {
  value = random_string.random_rg.result
}