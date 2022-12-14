resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
  location            = var.acr_resource_group_location
  sku                 = "Basic"
  admin_enabled       = false
}