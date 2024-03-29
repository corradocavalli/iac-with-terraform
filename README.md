# Infrastructure as Code with Terraform

Example of how to use [Terraform](https://www.terraform.io/) to deploy following infrastructure


- [App Service](https://azure.microsoft.com/en-us/services/app-service/) hosting Web API running into a docker container
- [PostgreSQL](https://www.postgresql.org/) database accessible from App Service via private V-Net
- [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) for sensitive information
- [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/) hosting App Service docker image
- Azure Active Directory [App Registration](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) for App Service authorization



This repository is described in detail in [this blog post](https://medium.com/corrado-cavalli/how-to-setup-an-app-service-database-using-private-v-net-and-authorize-access-via-azure-active-589eb93dc982).

