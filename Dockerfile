#--------------------------------------------------------------
# build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=0.12.13
FROM hashicorp/terraform:${TERRAFORM_VERSION}

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG VOLUME=/workspace
ARG ISTIO_VERSION=1.3.2
ARG HELM_VERSION=2.16.0

#--------------------------------------------------------------
# ENV
#--------------------------------------------------------------
# for workspace
ENV VOLUME /workspace
# for istio
ENV PATH=/istio-${ISTIO_VERSION}/bin:$PATH
ENV ISTIO_VERSION=${ISTIO_VERSION}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk upgrade && \
    apk add --no-cache make bash tar curl zip openssl py-pip && \
    # Install azure cli
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli `#Install Azure CLI` && \
    apk del --purge build && \
    # Install kubectl
    az aks install-cli && \
    # Install helm
    curl -OL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod 775 /usr/local/bin/helm && \
    # Install for CA Certiticate
    apk add --no-cache strongswan 2>&1 && \
    # Install Istio(https://istio.io/docs/setup/)
    curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

#--------------------------------------------------------------
# work directory
#--------------------------------------------------------------
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

#--------------------------------------------------------------
# setting shells
#--------------------------------------------------------------
ADD ./shell /shell
RUN chmod 775 /shell/* && \
    mv /shell/* /usr/local/bin/ && \
    rm -rf /shell

ENTRYPOINT []
CMD ["/usr/local/bin/cmd"]
