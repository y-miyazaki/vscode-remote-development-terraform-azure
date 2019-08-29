#!/bin/bash

#------------------------------------------------------------------------
# helm init for tiller.
# see tiller
# https://helm.sh/docs/glossary/
#------------------------------------------------------------------------

HELM_RBAC_FILE=$1

kubectl apply -f $HELM_RBAC_FILE
helm init --service-account tiller --node-selectors "beta.kubernetes.io/os"="linux"

# Check tiller
helm version
kubectl get serviceaccount -n kube-system | grep tiller
