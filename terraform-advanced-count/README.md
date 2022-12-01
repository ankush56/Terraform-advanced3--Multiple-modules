# terraform-azure-advanced2 ------------------
## (https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
## COUNT
## LOOP
## LENGTH
## FOREACH LOOP
## Always prefer to use for_each instead of count to create multiple copies of a resource.

## COUNT
** ** count is Terraform’s oldest, simplest, and most limited iteration construct: all it does is define how many copies of the resource to create. Here’s how you use count to create three IAM users:

```
resource "aws_iam_user" "example" {
  count = 3
  name  = "neo" # Note all 3 will have same name
}
```

## LOOP
## you can use count.index to get the index of each “iteration” in the “loop”:
```
resource "aws_iam_user" "example" {
  count = 3
  name  = "neo.${count.index}"  # Now name will be diff for each
}
```
** ** Names now will be - (“neo.0”, “neo.1”, “neo.2”):

Of course, a username like “neo.0” isn’t particularly usable. If you combine count.index with some built-in functions from Terraform, you can customize each “iteration” of the “loop” even more.

For example, you could define all of the IAM usernames you want in an input variable in live/global/iam/variables.tf:

```
variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  # default     = ["neo", "trinity", "morpheus"]
}
```
# Array lookup syntax: The syntax for looking up members of an array in Terraform is similar to most other programming languages: ARRAY[<INDEX>]. For example, here’s how you would look up the element at index 1 of var.user_names: var.user_names[1].

# The LENGTH function: Terraform has a built-in function called length that has the following syntax: length(<ARRAY>). As you can probably guess, the length function returns the number of items in the given ARRAY. It also works with strings and maps.
Putting these together, you get the following:
```
resource "aws_iam_user" "example" {
  count = length(var.user_names)      ----> LENGTH
  name  = var.user_names[count.index] -----> LOOP through array
}
```

# Note that after you’ve used count on a resource, it becomes an array of resources rather than just one resource. Because aws_iam_user.example is now an array of IAM users, instead of using the standard syntax to read an attribute from that resource (<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>), you must specify which IAM user you’re interested in by specifying its index in the array using the same array lookup syntax:

For example, if you want to provide the Amazon Resource Name (ARN) of the first IAM user in the list as an output variable, you would need to do the following:
```
output "first_arn" {
  value       = aws_iam_user.example[0].arn
  description = "The ARN for the first user"
}
```
If you want the ARNs of all of the IAM users, you need to use a splat expression, “*”, instead of the index:
```
output "all_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}
```
# FOR EACH LOOP
# Loops with for_each expressions
# The for_each expression allows you to loop over lists, sets, and maps to create (a) multiple copies of an entire resource, (b) multiple copies of an inline block within a resource, or (c) multiple copies of a module
```
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  for_each = <COLLECTION>
```
For example, here’s how you can create the same three IAM users using for_each on a resource:
```
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}
```
# Note the use of toset to convert the var.user_names list into a set. This is because for_each supports sets and maps only when used on a resource. When for_each loops over this set, it makes each username available in each.value. The username will also be available in each.key, though you typically use each.key only with maps of key-value pairs.

Once you’ve used for_each on a resource, it becomes a map of resources, rather than just one resource (or an array of resources as with count).

# 
# The fact that you now have a map of resources with for_each rather than an array of resources as with count is a big deal, because it allows you to remove items from the middle of a collection safely. For example, if you again remove “trinity” from the middle of the var.user_names list and run terraform plan, here’s what you’ll see:

$ terraform plan

Terraform will perform the following actions:
```
  # aws_iam_user.example["trinity"] will be destroyed
  - resource "aws_iam_user" "example" {
      - arn      = "arn:aws:iam::123456789012:user/trinity" -> null
      - name     = "trinity" -> null
    }
```
Plan: 0 to add, 0 to change, 1 to destroy.
# That’s more like it! You’re now deleting solely the exact resource you want, without shifting all of the other ones around.   
  
  
########################################
# FOR loop
# Terraform offers similar functionality in the form of a for expression (not to be confused with the for_each expression you saw in the previous section). The basic syntax of a for expression is as follows:
```
[for <ITEM> in <LIST> : <OUTPUT>]

for x in var.varname : upper(x) 
```
# where LIST is a list to loop over, ITEM is the local variable name to assign to each item in LIST, and OUTPUT is an expression that transforms ITEM in some way. For example, here is the Terraform code to convert the list of names in var.names to uppercase:

example- #FOR LOOP not for-each
```
variables-
variable "avengers" {
  type        = list(string)
}

.tfvars
avengers = [ "hulk", "spiderman", "ironman", "thor" ]

output.tf
output "upper_names" {
  value = [for x in var.avengers : upper(x)]
}
```
This will print all in uppercase

### Can also loop over map
# terraform.tfvars-
```
avengers_powers = {
    hulk      : "smash",
    spiderman  : "web",
    thor :  "lighting"
  }

# variables.tf
variable "avengers_powers" {
  type        = map(string)
  default     = {
    hulk      = "smash"
    spiderman  = "web"
    thor =  "lighting"
  }
}

# output.tf-
output "avengers_powers" {
  value = [for k, v in var.avengers_powers : " ${k} power is: ${v}"]
}
```

==========================================
Conditionals
** ** Just as Terraform offers several different ways to do loops, there are also several different ways to do conditionals, each intended to be used in a slightly different scenario:

** ** count parameter. Used for conditional resources
for_each and for expressions. Used for conditional resources and inline blocks within a resource
if string directive. Used for conditionals within a string


## If ELSE
## Terraform doesn’t support if-statements directly. However, you can accomplish the same thing by using the count parameter
## Terraform supports conditional expressions of the format <CONDITION> ? <TRUE_VAL> : <FALSE_VAL>.
## If you set count to 1 on a resource, you get one copy of that resource; 
## if you set count to 0, that resource is not created at all.
## Used with if-else. false will set count =0  which means resource wont be created

```
#  in tfvars
create_rg = false 

# variables.tf
variable "create_rg" {
  type        = bool
}

main.tf-
resource "azurerm_resource_group" "rg-test" {
    count = var.create_rg ? 1 : 0
    name     = "rg-test"
    location = var.resource_group_location
}
```
==========================================
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
