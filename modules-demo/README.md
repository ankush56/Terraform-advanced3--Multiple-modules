# Modules

## Terraform modules encapsulate groups of resources dedicated to one task, reducing the amount of code you have to develop for similar infrastructure components.

#### Problems that Terraform Modules Solve?

* Code Repetition
* Lack of code clarity and compliance

**The Root Module**
> Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the .tf files in the main working directory.

**Child Modules**
> A Terraform module (usually the root module of a configuration) can call other modules to include their resources into the configuration. A module that has been called by another module is often referred to as a child module.

Child modules can be called multiple times within the same configuration, and multiple configurations can use the same child module.

Module structure
```
root
    modules
        /module1
            main.tf
            variables.tf
            outputs.tf
        /module2
            main.tf
            variables.tf
            outputs.tf
main.tf (calls modules)
providers.tf
variables.tf
terraform.tfvars
```

## Create resource in modules/rg etc as we would normally do
## In root main.tf call that module

```
module "module_RG" {
  source                  = "./modules/resource_group_module"    #path to module
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

```

#### But, if you want to keep the module in a VCS (let’s assume git and GitHub), the source will need to point to the correct repository containing the appropriate version of the module that you’re calling

```
module "terraform_test_module" {
 source  = "git@github.com:your-organization/the-repository-name.git?ref=1.0.0"
```

#### Terraform modules can also be stored in so-called registries. Registries are places where you can find modules published by fellow Terraform users, or where you store the ones you have created—either privately, for your company/yourself, or publicly, for everyone to enjoy. A Terraform module called from a registry might look like this:

```
module "terraform_test_module" {
 source  = "<registry address/<organization>/<provider>/<module name>"
 version = "1.0.0"
[...]
```

**Declare outputs in module folder. When root main.tf calls it, it will show**
**terraform init in root folder**
**Use precompiled modules from terraform registry**
> [https://registry.terraform.io/]

