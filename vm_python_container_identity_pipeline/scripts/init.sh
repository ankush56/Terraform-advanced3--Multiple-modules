#!/bin/bash
mkdir /test
echo "hello" >> initlogs.txt
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
echo "Docker install complete" >> initlogs.txt
sleep 1m
echo "Installing azure cli" >> initlogs.txt
sudo apt-get update
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 
sleep 3m
az login --identity
az acr login --name ACR_NAME
echo "Pulling image" >> initlogs.txt
docker pull ACR_NAME.azurecr.io/IMAGE_NAME:latest
sleep 1m
docker run --name pythonapp -p 8081:8081 ACR_NAME.azurecr.io/IMAGE_NAME:latest