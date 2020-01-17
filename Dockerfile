#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=0.12.18
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS base

# ARG
ARG VOLUME=/workspace
ARG CLOUD_COMMANDS_VERSION=0.1.6

# ENV
ENV VOLUME /workspace

# Install dependent packages
RUN apk update && \
    apk add --no-cache make bash tar curl zip openssl py-pip

# setting commands
RUN git clone --depth 1 -b v${CLOUD_COMMANDS_VERSION} https://github.com/y-miyazaki/cloud-commands.git && \
    cloud-commands/install.sh && \
    rm -rf cloud-command

# work directory
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

# CMD
ENTRYPOINT []
CMD ["/usr/local/bin/azdockercmd"]

#--------------------------------------------------------------
# install azure-cli build image
#--------------------------------------------------------------
FROM base AS azure-cli

# ARG
ARG VOLUME=/workspace

# Install dependent packages
RUN apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli && \
    apk del --purge build

ENTRYPOINT []
# CMD
CMD ["/usr/local/bin/azdockercmd"]

#--------------------------------------------------------------
# helm build image
#--------------------------------------------------------------
FROM azure-cli AS helm

# ARG
ARG VOLUME=/workspace
ARG HELM_VERSION=2.16.1
ARG STERN_VERSION=1.11.0

# Install kubectl
RUN az aks install-cli && \
    # Install helm
    cd / && curl -OL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod 775 /usr/local/bin/helm && \
    rm -f helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    # install stern
    curl -LO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
    mv stern_linux_amd64 /usr/local/bin/stern && \
    chmod 775 /usr/local/bin/stern

ENTRYPOINT []
CMD ["/usr/local/bin/azdockercmd"]

#--------------------------------------------------------------
# istio build image
#--------------------------------------------------------------
FROM helm AS istio

# ARG
ARG VOLUME=/workspace
ARG ISTIO_VERSION=1.3.5

# ENV
# for istio
ENV PATH=/istio-${ISTIO_VERSION}/bin:$PATH
ENV ISTIO_VERSION=${ISTIO_VERSION}

# Install for CA Certiticate
# Install Istio(https://istio.io/docs/setup/)
RUN apk add --no-cache strongswan 2>&1 && \
    cd / && curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

ENTRYPOINT []
CMD ["/usr/local/bin/azdockercmd"]
