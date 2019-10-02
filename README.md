VSCode Remote Development for Terraform azure
===

## Overview
This repository used VSCode Remote Development and install Terraform/Google Cloud SDK 

## Description
### create devcontainer 
devcontainer used for VSCode Remote Development.  
https://code.visualstudio.com/docs/remote/remote-overview
```bash
$ cp -rp env/template env/{your environment}
$ cat env/{your environment}/.devcontainer/devcontainer.json
{
  "dockerFile": "../../../Dockerfile",
  "settings": {
    "terraform.lintPath": "/usr/local/bin/tflint",
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": ["esbenp.prettier-vscode", "mauve.terraform", "ipedrazas.kubernetes-snippets", "technosophos.vscode-helm"],
  "runArgs": [
    "-v",
    "${env:HOME}/##YOUR_WORKSPACE##:/workspace",
    "--env-file=../.env.##ENV##",
    "--name",
    "terraform-azure-##ENV##"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```
### change devcontainer.json  
"##ENV##" and "##YOUR_WORKSPACE##" fix in devcontainer.json.
1. ##YOUR_WORKSPACE## is your local directory for volume mount. If you want to absolute directory, don't need to ${env:HOME} value. 
1. ##ENV## is environment value.
```json
{
  "dockerFile": "../../../Dockerfile",
  "settings": {
    "terraform.lintPath": "/usr/local/bin/tflint",
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": ["esbenp.prettier-vscode", "mauve.terraform", "ipedrazas.kubernetes-snippets", "technosophos.vscode-helm"],
  "runArgs": [
    "-v",
    "${env:HOME}/workspace/hana_terraform:/workspace",
    "--env-file=.env",
    "--name",
    "terraform-azure-development"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```
### fix env/{environment}/.env.
You need to fix .env file.
```bash
$ cat env/{environment}/.env
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and google_project data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER={0|1}

#---------------------------------------------------------
# see
# https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/terraform-install-configure
#---------------------------------------------------------
# app_id used for az command and terraform
ARM_CLIENT_ID={set app_id from service principal}

# password used for az command and terraform
ARM_CLIENT_SECRET={set passowrd from service principal}

# tenant used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_TENANT_ID={set tenant_id from service principal}

# subscription id used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_SUBSCRIPTION_ID={set subscription_id from service principal}

#---------------------------------------------------------
# for terraform state
# see
# https://docs.microsoft.com/ja-jp/azure/terraform/terraform-backend
#---------------------------------------------------------
# Azure Storage Account Name for terraform state
STORAGE_ACCOUNT_NAME={storage account name}

# Azure Resource Group for terraform state
RESOURCE_GROUP_NAME={resource group name}

# Azure Container Name for terraform state
CONTAINER_NAME={container name}

# Azure Storage Account Access
# check console [Azure Storage Account -> Access Key Page]
# command)
# az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME}  --query [0].value -o tsv
ARM_ACCESS_KEY={storage account access key}
```
Here is example.
```
$ cat env/development/.env
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=development

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and google_project data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER=1
#---------------------------------------------------------
# see
# https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/terraform-install-configure
#---------------------------------------------------------
# app_id used for az command and terraform
ARM_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# password used for az command and terraform
ARM_CLIENT_SECRET=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# tenant used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# subscription id used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_SUBSCRIPTION_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

#---------------------------------------------------------
# for terraform state
# see
# https://docs.microsoft.com/ja-jp/azure/terraform/terraform-backend
#---------------------------------------------------------
# Azure Storage Account Name for terraform state
STORAGE_ACCOUNT_NAME=xxxxxxxxxxxxxxxxxx

# Azure Resource Group for terraform state
RESOURCE_GROUP_NAME=tfstate-resource-group

# Azure Container Name for terraform state
CONTAINER_NAME=tfstate

# Azure Storage Account Access
# check console [Azure Storage Account -> Access Key Page]
# command)
# az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME}  --query [0].value -o tsv
ARM_ACCESS_KEY=xxxxxxxxxxxxx/xxxxxxxxx/xxxxxxxxxxxxxxxxxx==
```

## Supplement
### VSCode Remote Development
You need to check this contents.  
https://code.visualstudio.com/docs/remote/containers

### terraform version
```bash
bash-4.4# terraform -v
Terraform v0.12.4
+ provider.azuread v0.6.0
+ provider.azurerm v1.33.0

Your version of Terraform is out of date! The latest version
is 0.12.7. You can update by downloading from www.terraform.io/downloads.html
```

### az/helm/kubectl versions
```
bash-4.4# az --version
azure-cli                         2.0.71 *

command-modules-nspkg               2.0.3
core                              2.0.71 *
nspkg                              3.0.4
telemetry                          1.0.3

Python location '/usr/bin/python'
Extensions directory '/root/.azure/cliextensions'

Python (Linux) 2.7.16 (default, May  6 2019, 19:35:26) 
[GCC 8.3.0]

Legal docs and information: aka.ms/AzureCliLegal



bash-4.4# helm version
Client: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
Error: Get http://localhost:8080/api/v1/namespaces/kube-system/pods?labelSelector=app%3Dhelm%2Cname%3Dtiller: dial tcp 127.0.0.1:8080: connect: connection refused



bash-4.4# kubectl version
Client Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.3", GitCommit:"2d3c76f9091b6bec110a5e63777c332469e0cba2", GitTreeState:"clean", BuildDate:"2019-08-19T11:13:54Z", GoVersion:"go1.12.9", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

## tf plan(terraform plan)
if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform plan.
main_init.tf is created by tf command.
```bash
$ tf plan
Initializing modules...

Initializing the backend...

Initializing provider plugins...

・・・・・・・・・・・・・・・・・・・・・・・・

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.

$ cat main_init.tf
#--------------------------------------------------------------
# main_init.tf must be not touch! because main_init.tf is auto generate file.
# If you want to fix it, you should be fix /shell/files/main.template.tf.
#--------------------------------------------------------------

#--------------------------------------------------------------
# terraform state
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    storage_account_name = "xxxxxxxxxxxxxxxxx"
    container_name = "tfstate"
    key = "terraform-tfstate"
  }
}

#--------------------------------------------------------------
# Provider Setting
#--------------------------------------------------------------
provider "azurerm" {
}
provider "azuread" {
 version = ">=0.3.0"
}
```

## tf apply(terraform apply)
if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform apply.
main_init.tf is created by tf command.
```bash
$ tf apply
Initializing modules...

Initializing the backend...

Initializing provider plugins...

・・・・・・・・・・・・・・・・・・・・・・・・

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
$ cat main_init.tf
#--------------------------------------------------------------
# main_init.tf must be not touch! because main_init.tf is auto generate file.
# If you want to fix it, you should be fix /shell/files/main.template.tf.
#--------------------------------------------------------------

#--------------------------------------------------------------
# terraform state
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    storage_account_name = "xxxxxxxxxxxxxxxxx"
    container_name = "tfstate"
    key = "terraform-tfstate"
  }
}

#--------------------------------------------------------------
# Provider Setting
#--------------------------------------------------------------
provider "azurerm" {
}
provider "azuread" {
 version = ">=0.3.0"
}
```

## Required
- Visual Code Studio Insiders  
https://code.visualstudio.com/insiders/
<!-- - Docker  
https://docs.docker.com/install/ -->

## Link
- Docker  
https://www.docker.com/
- Terraform  
https://www.terraform.io/
- Azure CLI  
https://docs.microsoft.com/ja-jp/cli/azure/?view=azure-cli-latest
- Kubernetes  
https://kubernetes.io/
- Helm  
https://helm.sh/

## Note
