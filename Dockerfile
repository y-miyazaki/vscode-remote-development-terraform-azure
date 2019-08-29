FROM hashicorp/terraform:0.12.4

ARG VOLUME=/workspace
ENV VOLUME /workspace

# Install dependent packages
RUN apk add --no-cache make bash tar curl zip py-pip openssl && \
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli `#Install Azure CLI` && \
    apk del --purge build
# Install kubectl and helm
RUN az aks install-cli && \
    curl -L https://git.io/get_helm.sh | bash `# Install Helm`

# tflint
# RUN wget https://github.com/wata727/tflint/releases/download/v0.1.0/tflint_linux_amd64.zip && \
#     unzip tflint_linux_amd64.zip && \
#     mkdir -p /usr/local/tflint/bin && \
#     install tflint /usr/local/tflint/bin && \
#     rm -f tflint_linux_amd64.zip tflint && \
#     echo "PATH=/usr/local/tflint/bin:$PATH" >> $HOME/.bashrc

# work directory
RUN mkdir -p ${VOLUME}
WORKDIR ${VOLUME}

# setting shells
ADD ./shell /shell
ADD ./env /env
RUN chmod 775 /shell/*.sh && \
mv /shell/terraform_init_state.sh /usr/local/bin/tf_init_state && \
mv /shell/terraform.sh /usr/local/bin/tf && \
mv /shell/k8s_info.sh /usr/local/bin/k8s_info && \
mv /shell/k8s_help.sh /usr/local/bin/k8s_help

ENTRYPOINT []
CMD ["/shell/cmd.sh"]
