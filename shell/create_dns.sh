#!/bin/bash
#------------------------------------------------------------------------
# Associate DNS to Public IP Address
#------------------------------------------------------------------------

NAME=`basename $0`
# Public IP address of your ingress controller
IP=$1
# Name to associate with public IP address
DNSNAME=$2

if [ -z $IP ]; then
  echo "usage: ./${NAME} {public ip} {dns name}" 1>&2
  exit 1
fi

if [ -z $DNSNAME ]; then
  echo "usage: ./${NAME} {public ip} {dns name}" 1>&2
  exit 1
fi

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME
