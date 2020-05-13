#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=latest
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS base

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG VOLUME=/workspace
ARG CLOUD_COMMANDS_VERSION=v0.2.7

#--------------------------------------------------------------
# ENV
#--------------------------------------------------------------
ENV VOLUME /workspace

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk add --no-cache make bash tar curl zip openssl py-pip sudo && \
    # setting commands
    git clone --depth 1 -b ${CLOUD_COMMANDS_VERSION} https://github.com/y-miyazaki/cloud-commands.git && \
    cloud-commands/install.sh && \
    rm -rf cloud-command && \
    # Install az command
    apk add --no-cache python3-dev && \
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev  && \
    pip3 --no-cache-dir install -U pip && \
    pip3 --no-cache-dir install mock==4.0.2 && \
    pip3 --no-cache-dir install azure-cli && \
    apk del --purge build

# work directory
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

# CMD
ENTRYPOINT []
CMD ["/usr/local/bin/azdockercmd"]
