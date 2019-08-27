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
  "extensions": ["esbenp.prettier-vscode", "mauve.terraform"],
  "runArgs": [
    "-v",
    "${env:HOME}/##YOUR_WORKSPACE##:/workspace",
    "--env-file=.env",
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
  "extensions": ["esbenp.prettier-vscode", "mauve.terraform"],
  "runArgs": [
    "-v",
    "${env:HOME}/workspace/terraform:/workspace",
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
# default project id gcloud command and terraform
PROJECT_ID={azure project id}
# default region uses gcloud command and terraform
REGION={azure main region}
# default zone uses gcloud command and terraform
ZONE={azure main region zone}
# terraform state gcs bucket name.
BUCKET={gcs terraform state bucket}
# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and google_project data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER={0|1}
# GOOGLE_CLOUD_KEYFILE_JSON uses gcloud auth command and init provider.
GOOGLE_CLOUD_KEYFILE_JSON=/env/{environment}/.key
```
Here is example.
```
$ cat env/development/.env
ENV=development
PROJECT_ID=pure-ace-xxxxxxxx
REGION=us-west1
ZONE=us-west1-a
BUCKET=test-terraform-state
IS_GENERATE_PROVIDER=0
GOOGLE_CLOUD_KEYFILE_JSON=/env/development/.key
```
### fix env/{environment}/.key.
You need to fix .key file.  
This file is Service Account Key json. Please check this following page.  
https://cloud.google.com/iam/docs/creating-managing-service-account-keys  
  
Here is example.
```json
$ cat env/development/.key
{
"type": "service_account",
"project_id": "[PROJECT-ID]",
"private_key_id": "[KEY-ID]",
"private_key": "-----BEGIN PRIVATE KEY-----\n[PRIVATE-KEY]\n-----END PRIVATE KEY-----\n",
"client_email": "[SERVICE-ACCOUNT-EMAIL]",
"client_id": "[CLIENT-ID]",
"auth_uri": "https://accounts.google.com/o/oauth2/auth",
"token_uri": "https://accounts.google.com/o/oauth2/token",
"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/[SERVICE-ACCOUNT-EMAIL]"
}
```

## Supplement
### VSCode Remote Development
You need to check this contents.  
https://code.visualstudio.com/docs/remote/containers

### terraform version
```bash
bash-4.4# terraform -v
Terraform v0.12.4
+ provider.google v2.12.0

Your version of Terraform is out of date! The latest version
is 0.12.6. You can update by downloading from www.terraform.io/downloads.html
```

### gcloud version and gcloud config list
```
bash-4.4# gcloud -v
Google Cloud SDK 257.0.0
bq 2.0.46
core 2019.08.02
gsutil 4.41
kubectl 2019.08.02
bash-4.4# gsutil -v
gsutil version: 4.41
bash-4.4# gcloud config list
[core]
account = xxxxxxxxxxxxx@xxxxxxxxxxxxx.iam.gserviceaccount.com
disable_usage_reporting = False
project = xxxxxxxxxxxxx

Your active configuration is: [default]
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
- Google Cloud SDK  
https://cloud.google.com/sdk/downloads

## Note
