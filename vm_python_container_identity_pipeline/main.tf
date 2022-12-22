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

# Create Vnet with a subnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location # reference another resource- dependency
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/23"]
}


resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create NSG Rule
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Development"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgapply" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Public IP 
resource "azurerm_public_ip" "ip1" {
  name                = "ip1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

# Create NIC
resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip1.id
  }
}


# Setup ssh key to login to VM
# Create (and display) an SSH key
resource "tls_private_key" "my_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.my_ssh.private_key_pem
  filename        = "myssh.pem"
  file_permission = "0600"
}



#######################################################################
# Build image from docker file
# Push image to ACR
# Local exec
# Let you run commands on machine running terrafform
#######################################################################
resource "null_resource" "builddockercmds" {
  provisioner "local-exec" {
    command = "az acr login --name ${var.acr_name} && docker build --no-cache --file Dockerfile --tag ${azurerm_container_registry.acr.login_server}/${var.image_name}:latest . && docker push ${azurerm_container_registry.acr.login_server}/${var.image_name}:latest"
  }
}

#Run local commands to edit init file that runs on vm
# This will replace image name with our variables value
# Replace template ACR_NAME with variable values from terraform variables file
resource "null_resource" "initfileupdate" {
  provisioner "local-exec" {
    command = "sed -i'' -e 's/ACR_NAME/${var.acr_name}/g' ./scripts/init.sh && sed -i'' -e 's/IMAGE_NAME/${var.image_name}/g' ./scripts/init.sh "
  }
}

# Create Virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  custom_data           = base64encode(file("scripts/init.sh"))
  size                  = "Standard_B1ls"
  identity {
    type = "SystemAssigned"
  }


  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true


  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.my_ssh.public_key_openssh
  }
}
# Grant the "Reader" role to a user on the ACR registry

#In this example, the azurerm_role_assignment resource grants the "ACRPULL" role to the user
# with the specified principal_id on the ACR registry. 
# You can replace the role_definition_name and principal_id values with
# the appropriate values for your situation.
# Set this when u create VM
#  identity {
#    type = "SystemAssigned"
#  }
#
resource "azurerm_role_assignment" "role1" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

# resource "null_resource" "setinitfileupdatetodefault" {
#   provisioner "local-exec" {
#     command = "sed -i'' -e 's/${var.acr_name}/ACR_NAME/g' ./scripts/init.sh && sed -i'' -e 's/${var.image_name}/IMAGE_NAME/g' ./scripts/init.sh"
#   }
# }