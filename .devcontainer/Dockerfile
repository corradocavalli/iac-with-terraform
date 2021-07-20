
ARG PYTHON_VERSION="3.7.10"
FROM python:${PYTHON_VERSION}-buster

ARG TERRAFORM_VERSION="0.14.7"
ARG DOCKER_COMPOSE_VERSION="1.28.5"
ENV DEBIAN_FRONTEND=noninteractive

ADD .devcontainer/requirements.txt /tmp/requirements.txt
ADD src/libs /workspaces/tf-api-post/src/libs

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential 

# Install python libareries
# As soon as possible, so we can override the docker-compose version later further down
RUN pip install -r /tmp/requirements.txt \  
    && pip install -e /workspaces/tf-api-post/src/libs \
    && pip install uvicorn[standard]==0.13.4

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Install Docker CE CLI
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \   
    # Install docker compose. Note, this will override what was installed via pip install thru iotedgedev
    && curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \    
    # Install Terraform
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin 

ENV DEBIAN_FRONTEND=dialog