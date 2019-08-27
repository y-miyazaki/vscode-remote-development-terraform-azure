#!/bin/sh
#--------------------------------------------------------------
# Create Azure Storage for terraform state.
# You set Azure Storage Name to this shell, create Azure Storage.
# Azure Storage Name adds suffix of Container Name hash for unique name.
#--------------------------------------------------------------
set -e

NAME=`basename $0`
STORAGE_ACCOUNT_NAME=$1
if [ -z $STORAGE_ACCOUNT_NAME ]; then
  echo "usage: ./${NAME} {service account name} {resource group name} {container name} {location} {is storage account name random suffix}" 1>&2
  exit 1
fi
RESOURCE_GROUP_NAME=$2
if [ -z $RESOURCE_GROUP_NAME ]; then
  echo "usage: ./${NAME} {service account name} {resource group name} {container name} {location} {is storage account name random suffix}" 1>&2
  exit 1
fi
CONTAINER_NAME=$3
if [ -z $CONTAINER_NAME ]; then
  echo "usage: ./${NAME} {service account name} {resource group name} {container name} {location} {is storage account name random suffix}" 1>&2
  exit 1
fi
LOCATION=$4
if [ -z $LOCATION ]; then
  echo "usage: ./${NAME} {service account name} {resource group name} {container name} {location} {is storage account name random suffix}" 1>&2
  exit 1
fi

# option: add hash suffix to bucket name.
IS_STORAGE_ACCOUNT_NAME_AUTO_HASH=$5
if [ "${IS_STORAGE_ACCOUNT_NAME_AUTO_HASH}" -eq "1" ]; then
  RM=`awk -v min=1000000000 -v max=10000000000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`
  STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME}${RM}"
fi

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
