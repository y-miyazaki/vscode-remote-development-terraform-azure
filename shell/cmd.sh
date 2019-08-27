#!/bin/bash

# az login
if [ -n ${ARM_CLIENT_ID} ] && [ -n ${ARM_CLIENT_SECRET} ] && [ -n ${ARM_TENANT_ID} ]; then
    az login --service-principal --username ${ARM_CLIENT_ID} --password ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}
fi

# keep container.
tail -f /dev/null
