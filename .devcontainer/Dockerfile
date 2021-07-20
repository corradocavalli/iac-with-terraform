
ARG VARIANT="5.0"
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ARG TERRAFORM_VERSION="0.14.7"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends build-essential unzip\
    # Install the Azure CLI
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Install Docker CE CLI
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \       
    # Install Terraform
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin 
ENV DEBIAN_FRONTEND=dialog