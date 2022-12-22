# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create Azure key vault
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "akv" {
  name                        = var.vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = "d6487ac0-c72b-4521-acb8-d1c71f389cc3"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    #  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    #  object_id = "${data.azurerm_client_config.current.service_principal_object_id}"
    tenant_id       = "d6487ac0-c72b-4521-acb8-d1c71f389cc3"
    object_id       = "61facd92-3124-424a-8454-6cf2885ed8bf"
    key_permissions = ["Get", "Create", "List"]

    secret_permissions = ["Get", "List", "Set"]

    storage_permissions = ["Get", "List", "Set"]
  }
}
#Random password
resource "random_password" "admin_random_password" {
  length  = 20
  special = true
}

# Create secret
resource "azurerm_key_vault_secret" "my_secret" {
  name         = "mysecret"
  value        = random_password.admin_random_password.result
  key_vault_id = azurerm_key_vault.akv.id
}