# Terraform docs https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
# Backend info must go in main terraform block
# Add storage account already created details- create first storage account and container in it
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "teststorageterra1234"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"  
  }
  
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}