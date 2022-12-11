# CUSTOM SCRIPTS
## Configure VM after creation with terraform
## Install and configure NGINX

>   **custom_data**: You need to install docker and run nginx in a container once our instance launches. 
>   The custom_data argument achieves this. You can embed the commands in our main.tf itself or more 
>   conveniently create one sh file and pass that to the custom_data argument. 

**The custom data should be base64 encoded that is why we use a function called base64encode to encode the data in the script** 

>  create one scripts/init.sh file and paste the below code

main.tf
```
resource "azurerm_linux_virtual_machine" "nginx" {
   size = var.instance_size
   name = "nginx-webserver"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
   custom_data = base64encode(file("scripts/init.sh")) . #Provide post install script path
```

> Script to configure
```
#!/bin/bash
#Installing Docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce -y
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl restart docker
sudo docker run --name docker-nginx -p 80:80 nginx:latest
```

>   You can also explore the terraform show command to see the provisioned infrastructure’s detailed information.

>   Once logged in, run docker ps and see the running nginx container. Next, curl localhost, and you should visit the default nginx webpage.