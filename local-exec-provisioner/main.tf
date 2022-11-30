# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}


#######################################################################
  # Local exec
  # Let you run commands on machine running terrafform
#######################################################################
resource "null_resource" "dockercmds" {
  provisioner "local-exec" {
    command = "az acr login --name ${var.acr_name} && docker pull alpine && docker tag alpine:latest ${azurerm_container_registry.acr.login_server}/alpine:latest && docker push ${azurerm_container_registry.acr.login_server}/alpine:latest"
  }
}

# Run some scripts
resource "null_resource" "pythoncmds" {
  provisioner "local-exec" {
    command = "test.py"
    interpreter = ["python"]
  }
}

#######################################################################
  # remote exec
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  # Let you run commands on remote machine
  # The remote-exec provisioner invokes a script on a remote resource after it is created. 
  # This can be used to run a configuration management tool, bootstrap into a cluster, etc
  # 3 Arguments can be used
  #   Inline - List of commands strings
  #   Script - This is a path (relative or absolute) to a local script that will be copied to the remote resource and then executed
#######################################################################

