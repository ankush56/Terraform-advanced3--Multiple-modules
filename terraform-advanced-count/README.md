# terraform-azure-advanced2
#   Notes--------------------------
console for various tasks like checking variables values
> terraform console

New file- terraform.tfvars--> Dont check into repo for most cases
define variables in variables.tf without default value and set them in terraform.tfvars


# OVERRIDE VARIABLE VALUE IN VARIBALES.TF
$ terraform console -var="host_os=linux"
> var.host_os
"linux"

#read vars from any other file
terraform console -var-file="some.tfvars"

some.tfvars will override terraform.tfvars and terraform.tfvars will override variables.tf default value
====================================================
# Notes
# Create 3 resource groups with count
Define 3 file-
main.tf
variables.tf
terraform.tfvars

In variables.tf define a list variable- no default value
In terraform.tfvars provide values for rg-groups-list
main.tf-->create resource 

