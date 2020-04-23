#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=0.12.23
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS base

# ARG
ARG VOLUME=/workspace
ARG CLOUD_COMMANDS_VERSION=v0.2.5

# ENV
ENV VOLUME /workspace

# Install dependent packages
RUN apk update && \
    apk add --no-cache make bash tar curl zip openssl py-pip sudo && \
    # setting commands
    git clone --depth 1 -b ${CLOUD_COMMANDS_VERSION} https://github.com/y-miyazaki/cloud-commands.git && \
    cloud-commands/install.sh && \
    rm -rf cloud-command

# work directory
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

# copy repository
COPY . .

# CMD
ENTRYPOINT []
CMD []
