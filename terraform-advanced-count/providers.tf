# Terraform docs https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}