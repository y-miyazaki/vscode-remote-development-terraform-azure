# VSCode Remote Development for Terraform azure

## Overview

This repository used VSCode Remote Development and install Terraform/Azure CLI
## Description

### create devcontainer

devcontainer used for VSCode Remote Development.
https://code.visualstudio.com/docs/remote/remote-overview

```json
$ cp -rp env/template env/{your environment}
$ cat env/{your environment}/.devcontainer/devcontainer.json
{
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-azure:latest",
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": [
    "mauve.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
    "editorconfig.editorconfig",
    "esbenp.prettier-vscode",
    "ibm.output-colorizer",
    "streetsidesoftware.code-spell-checker",
    "vscode-icons-team.vscode-icons",
  ],
  "runArgs": [
    "-v",
    "${env:HOME}/##YOUR_WORKSPACE##:/workspace",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### change devcontainer.json

"##ENV##" and "##YOUR_WORKSPACE##" fix in devcontainer.json.

1. ##YOUR_WORKSPACE## is your local directory for volume mount. If you want to absolute directory, don't need to \${env:HOME} value.

```json
{
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-azure:latest",
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": [
    "mauve.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
    "editorconfig.editorconfig",
    "esbenp.prettier-vscode",
    "ibm.output-colorizer",
    "streetsidesoftware.code-spell-checker",
    "vscode-icons-team.vscode-icons",
  ],
  "runArgs": [
    "-v",
    "${env:HOME}/workspace/terraform:/workspace",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### env/template/.env

You need to fix .env file.

```shell
$ cat env/template/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and google_project data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER={0|1}

#---------------------------------------------------------
# Install and configure Terraform to provision Azure resources
# https://docs.microsoft.com/azure/virtual-machines/linux/terraform-install-configure
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
# Store Terraform state in Azure Storage
# https://docs.microsoft.com/azure/terraform/terraform-backend
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

```shell
$ cat env/development/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=development

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and google_project data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER=1

#---------------------------------------------------------
# Install and configure Terraform to provision Azure resources
# https://docs.microsoft.com/azure/virtual-machines/linux/terraform-install-configure
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
# Store Terraform state in Azure Storage
# https://docs.microsoft.com/azure/terraform/terraform-backend
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
bash-5.0# terraform -v
Terraform v0.12.25
```

### az versions

```
bash-5.0# az --version
azure-cli                         2.0.76

command-modules-nspkg              2.0.3
core                              2.0.76
nspkg                              3.0.4
telemetry                          1.0.4

Python location '/usr/bin/python'
Extensions directory '/root/.azure/cliextensions'

Python (Linux) 2.7.16 (default, May  6 2019, 19:28:45)
[GCC 8.3.0]

Legal docs and information: aka.ms/AzureCliLegal


Your CLI is up-to-date.
```

## aztf plan(terraform plan)

if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform plan.
main_init.tf is created by aztf command.

```bash
$ aztf plan
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

## aztf apply(terraform apply)

if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform apply.
main_init.tf is created by aztf command.

```bash
$ aztf apply
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

- Visual Code Studio  
  https://code.visualstudio.com/download
- Docker  
  https://www.docker.com/

## Other Link

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
- Stern  
  https://github.com/wercker/stern

## Note
