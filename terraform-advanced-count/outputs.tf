output "first_rg" {
  value       = azurerm_resource_group.rg[0].id
  description = "ID of first resource group"
}

output "all_rg" {
  value       = azurerm_resource_group.rg[*].id
  description = "ID of first resource group"
}

# Outputs with foreach as it creates a map
output "all_acr_id" {
  value = values(azurerm_container_registry.acr)[*].id
}

output "all_acr" {
  value = values(azurerm_container_registry.acr)[*].login_server
}

#FOR LOOP not for-each
output "upper_names" {
  value = [for x in var.avengers : upper(x)]
}

output "avengers_powers" {
  value = [for k, v in var.avengers_powers : " ${k} power is: ${v}"]
}