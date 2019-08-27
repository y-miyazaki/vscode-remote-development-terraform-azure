#!/bin/bash

echo "------------------------------------------------------------------------"
echo "helm init"
echo "------------------------------------------------------------------------"
echo "helm init"
echo -e "\n"

echo "------------------------------------------------------------------------"
echo "helm init and rbac"
echo "------------------------------------------------------------------------"
echo "helm init --service-account tiller --node-selectors \"beta.kubernetes.io/os\"=\"linux\""
echo -e "\n"

echo "------------------------------------------------------------------------"
echo "helm install for upload kubernetes cluster"
echo "------------------------------------------------------------------------"
echo "helm init --service-account tiller --node-selectors \"beta.kubernetes.io/os\"=\"linux\""
echo -e "\n"

echo "------------------------------------------------------------------------"
echo "helm package"
echo "------------------------------------------------------------------------"
echo "helm package {package name}"
echo -e "\n"

echo "------------------------------------------------------------------------"
echo "helm upgrade(install)"
echo "------------------------------------------------------------------------"
echo "helm upgrade --install {release name} {chart path}"
echo -e "\n"
