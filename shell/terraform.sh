#!/bin/sh

set -e

# terraform command
COMMAND=$1

# terraform key
KEY=`cat terraform.key | sed -e "s/[\r\n]\+//g"`
if [ -z $KEY ]; then
  KEY=terraform-tfstate
fi

# if [ $COMMAND = "destroy" ]; then
#   echo "terraform destroies command can't access now."
#   exit 1
# fi

# check environment
if [ -z $ENV ]; then
  echo "terraform needs ENV environment parameter."
  exit 1
fi
if [ -z $ARM_CLIENT_ID ]; then
  echo "terraform needs ARM_CLIENT_ID environment parameter."
  exit 1
fi
if [ -z $ARM_CLIENT_SECRET ]; then
  echo "terraform needs ARM_CLIENT_SECRET environment parameter."
  exit 1
fi
if [ -z $ARM_TENANT_ID ]; then
  echo "terraform needs ARM_TENANT_ID environment parameter."
  exit 1
fi
if [ -z $ARM_SUBSCRIPTION_ID ]; then
  echo "terraform needs ARM_SUBSCRIPTION_ID environment parameter."
  exit 1
fi
if [ -z $STORAGE_ACCOUNT_NAME ]; then
  echo "terraform needs STORAGE_ACCOUNT_NAME environment parameter."
  exit 1
fi
if [ -z $RESOURCE_GROUP_NAME ]; then
  echo "terraform needs RESOURCE_GROUP_NAME environment parameter."
  exit 1
fi
if [ -z $CONTAINER_NAME ]; then
  echo "terraform needs CONTAINER_NAME environment parameter."
  exit 1
fi
if [ -z $IS_GENERATE_PROVIDER ]; then
  echo "terraform needs IS_GENERATE_PROVIDER environment parameter."
  exit 1
fi

# export TF_LOG=1
# export TF_LOG_PATH='./terraform.log'
rm -f terraform.log crash.log main_init.tf
if [ $IS_GENERATE_PROVIDER -eq "1" ]; then
    cat /shell/files/main.template.tf | sed -e "s/##STORAGE_ACCOUNT_NAME##/${STORAGE_ACCOUNT_NAME}/g" > ./main_init.tf
    cat ./main_init.tf | sed -i -e "s@##CONTAINER_NAME##@${CONTAINER_NAME}@g" ./main_init.tf
    cat ./main_init.tf | sed -i -e "s@##KEY##@${KEY}@g" ./main_init.tf
fi
terraform init
terraform $COMMAND -var-file=terraform.$ENV.tfvars 
