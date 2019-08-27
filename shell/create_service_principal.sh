#!/bin/sh

az login
az ad sp create-for-rbac -n "terraform" --role contributor
az account show --query "{subscriptionId:id, tenantId:tenantId}"

if [ -z $ARM_CLIENT_ID ]; then
    # Azure Active Directory Graph->Application.ReadWrite.All
    az ad app permission add --id $ARM_CLIENT_ID --api 00000002-0000-0000-c000-000000000000 --api-permissions 311a71cc-e848-46a1-bdf8-97ff7156d8e6=Role
    # Azure Active Directory Graph->Directroy.Read.All
    az ad app permission add --id $ARM_CLIENT_ID --api 00000002-0000-0000-c000-000000000000 --api-permissions 5778995a-e1bf-45b8-affa-663a9f3f4d04=Role
    # check permission
    az ad app permission list --id $ARM_CLIENT_ID
fi
