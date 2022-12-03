output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_url" {
  value = azurerm_container_registry.acr.login_server
}