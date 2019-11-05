FROM hashicorp/terraform:0.12.9

ARG VOLUME=/workspace
ENV VOLUME /workspace

# for istio
ENV PATH=/istio-1.3.2/bin:$PATH
ENV ISTIO_VERSION=1.3.2

# Install dependent packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache make bash tar curl zip openssl py-pip jq && \
    # Install azure cli
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli `#Install Azure CLI` && \
    apk del --purge build && \
    # Install kubectl and helm
    az aks install-cli && \
    curl -L https://git.io/get_helm.sh | bash `# Install Helm` && \
    # Install for CA Certiticate
    apk add --no-cache strongswan 2>&1 && \
    # Install Istio(https://istio.io/docs/setup/)
    curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.3.2 sh -

# work directory
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

# setting shells
ADD ./shell /shell
RUN chmod 775 /shell/* && \
mv /shell/* /usr/local/bin/ && \
rm -rf /shell

ENTRYPOINT []
CMD ["/usr/local/bin/cmd"]
