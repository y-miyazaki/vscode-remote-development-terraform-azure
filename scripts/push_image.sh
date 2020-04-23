#!/bin/bash
set -e

docker build -f ../docker/default/Dockerfile -t ymiyazakixyz/terraform-azure:latest .
docker push ymiyazakixyz/terraform-azure:latest
