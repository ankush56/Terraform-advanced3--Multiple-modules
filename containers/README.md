# Data Separation-Different vars for different envs like dev, sit, pat
# main.tf
# variables.tf   - Declare var (prvovide default if can be set)
# terraform.tfvars  - Provide values - default tfvars file
# Create folder for each envs- dev, sit, pat, prod
# Create tfvars in each env folder(DEV, SIT, PAT) to separate data. Have env specific values here
# Use var in main.tf- var.varname*

>  terraform apply -var-file dev/dev.tfvars
>  terraform apply -var-file pat/tfvars
> terraform apply -var-file dev.tfvars
# Or to override value of variable
> terraform apply -v "rg_group_name=centralus"
