#!/bin/bash
# ------------------------------------------------------------------------
# see)
# https://docs.microsoft.com/ja-jp/azure/aks/ingress-static-ip
# ------------------------------------------------------------------------
NAME=`basename $0`
IP=$1

if [ -z $IP ]; then
  echo "usage: ./${NAME} {public ip}" 1>&2
  exit 1
fi

# Create a namespace for your ingress resources
# kubectl create namespace ingress-basic

# Use Helm to deploy an NGINX ingress controller
helm install stable/nginx-ingress \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="$IP" \
    --name nginx-ingress

# check service nginx ingress
echo "# ------------------------------------------------------------------------"
echo "# Nginx Ingress associates ip address now."
echo "# Please check this following command."
echo "# ------------------------------------------------------------------------"
echo "kubectl get service -l app=nginx-ingress --namespace ingress-basic"
