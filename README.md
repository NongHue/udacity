# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

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


1. Create packer image
- Run az group create to create a resource group to hold the Packer image.

`az group create -n myPackerImages -l eastus`

- Run az account show to display the current Azure subscription.

`az account show --query "{ subscription_id: id }"`

- Run az ad sp create-for-rbac to enable Packer to authenticate to Azure using a service principal.

`az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

- Add environment variables: 

`export ARM_CLIENT_ID="xxx"`

`export ARM_CLIENT_SECRET="xxx"`

`export ARM_SUBSCRIPTION_ID="xxx"`

- Build the Packer image.

`packer build server.json`

2. Implement the Terraform code
- Run terraform init to initialize the Terraform deployment.

`terraform init`

- Run terraform plan to create an execution plan.

`terraform plan -out solution.plan`

- Run terraform apply to apply the execution plan to your cloud infrastructure.

`terraform apply "solution.plan"`


### Output
You see values for the following:

- Virtual machine FQDN (3 machine)
- Jumpbox FQDN
- Jumpbox IP address
 