# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.
The packer image baseline on Ubuntu 18.04-LTS SKU
Use terraform to deploy resources: resource group, virtual network and a subnet on  the virtual network, network interface, public ip, load balancerwith backend pool, availability set, managed disk,  3 virtual machines using packer and attact managed disk created

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Customize variables in vars.tf, terraform.tfvars
- Update your resources name

- Update the number of resources

- Update the resources location 

2. Create packer image
- Run az group create to create a resource group to hold the Packer image.

`az group create -n myPackerImages -l eastus`

- Run az account show to display the current Azure subscription.

`az account show --query "{ subscription_id: id }"`

- Run az ad sp create-for-rbac to enable Packer to authenticate to Azure using a service principal.

`az ad sp create-for-rbac --role Contributor --scopes /subscriptions/0d907712-4c87-470a-8313-70c6567f5990 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

- Add environment variables: 

`export ARM_CLIENT_ID="e7e50341-bd5b-40fd-b64c-51e8b85bf32f"`

`export ARM_CLIENT_SECRET="tS9TLVhjooAgzvTZ5UbbJPnD-T07_z6.Mp"`

`export ARM_SUBSCRIPTION_ID="0d907712-4c87-470a-8313-70c6567f5990"`

- Build the Packer image.

`packer build server.json`

3. Implement the Terraform code
- Run terraform init to initialize the Terraform deployment.

`terraform init`

- Run terraform plan to create an execution plan.

`terraform plan -out solution.plan`

- Run terraform apply to apply the execution plan to your cloud infrastructure.

`terraform apply "solution.plan"`

### Output
You see values for the following:

- A security group 

- 3 virtual machines

- 3 network interfaces

- azurerm_network_security_rule 

- azurerm_network_security_group 

- a azurerm_public_ip 

...
 
### Destroy resource after verify
Run terraform destroy to destroy all the resources 
`terraform destroy`
