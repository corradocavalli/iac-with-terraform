# Dependencies versions
ARG TERRAFORM_VERSION="0.14.7"
ARG TFLINT_VERSION="0.22.0"
ARG DOCKER_COMPOSE_VERSION="1.28.5"
ARG NODE_VERSION="15.x"
ARG SHELLCHECK_VERSION="0.5.0-3"
ARG AZURE_CLI_VERSION="2.24.0-1~buster"
ADD .devcontainer/requirements.txt /tmp/requirements.txt
ADD .devcontainer/requirements-saas.txt /tmp/requirements-saas.txt
ADD src/edge/modules/ /workspaces/Sense-Microsoft/src/edge/modules
ADD src/saas/libs /workspaces/Sense-Microsoft/src/saas/libs

# Environment variables
ENV NO_KEY_VAULT="true" 

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential jq

# Install python libareries
# As soon as possible, so we can override the docker-compose version later further down
RUN pip install -r /tmp/requirements.txt \
    && pip install -r /tmp/requirements-saas.txt \
    && pip install -e /workspaces/Sense-Microsoft/src/edge/modules \
    && pip install -e /workspaces/Sense-Microsoft/src/saas/libs \
    # Install uvicorn in a separate command to avoid conflicts with iotedgedev
    && pip install uvicorn[standard]==0.13.4

RUN \
    # Install node and npm
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get install -y nodejs \
    # Install the Azure CLI and IoT extension
    && apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update && apt-get install azure-cli=${AZURE_CLI_VERSION} \
    && az extension add --name azure-iot --system \
    # Install Docker CE CLI
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    # Install ShellCheck
    && apt-get install shellcheck=${SHELLCHECK_VERSION} \
    # Install docker compose. Note, this will override what was installed via pip install thru iotedgedev
    && curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    # Install markdown linters
    && npm install markdown-spellcheck@${MD_SPELLCHECK_VERSION} -g \
    && npm install markdown-link-check@${MD_LINK_CHECK_VERSION} -g \
    && npm install markdownlint-cli@${MD_LINT_VERSION} -g \
    # Install Terraform
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin \    
    # Install bash completion
    && apt-get update \
    && apt-get -y install bash-completion \
    && echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc \
    # Clean up downloaded files
    && cd ~ \ 
    && rm -rf /tmp/*