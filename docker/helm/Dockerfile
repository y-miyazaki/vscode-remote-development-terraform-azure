#--------------------------------------------------------------
# helm build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=latest
FROM ymiyazakixyz/terraform-azure:${TERRAFORM_VERSION} AS helm

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
