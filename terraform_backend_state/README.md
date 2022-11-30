Terraform Backend
# Store data oin remote site
# https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli

Create a storage account and container inside it if not done before on Portal
Add backend details to providers.tf
Run terraform init now
It will create terraform.tfstate in the container of blob in storage account for team working otherwise its local

On local if I change anything it will update localtfstate file but on remote any script in team setting can refer particulat state from tfstate file


Terraform doesnt really reference azure but terraform.tftstate
If we add azure "lock" on storage account. so terraform.tftstate become readonly; Terraform wont creata , apply , destroy etc
