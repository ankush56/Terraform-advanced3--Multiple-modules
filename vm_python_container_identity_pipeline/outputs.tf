output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name_subnet" {
  value = azurerm_virtual_network.vnet.subnet
}

output "nsgrules" {
  value = azurerm_network_security_group.nsg.name
}

output "public_ip" {
  value = azurerm_public_ip.ip1.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.nic1.private_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.my_ssh.private_key_pem
  sensitive = true
}

output "acr_login" {
  value = azurerm_container_registry.acr.login_server
}

