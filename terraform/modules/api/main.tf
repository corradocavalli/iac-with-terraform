resource "random_string" "pgs-username" {
  length    = 10
  special   = false
  number    = false
  min_lower = 1
  min_upper = 1
}

resource "random_string" "pgs-password" {
  length      = 10
  min_lower   = 1
  min_upper   = 1
  min_special = 1
  min_numeric = 1
}

resource "random_string" "pgs-db-name" {
  length    = 10
  special   = false
  number    = false
  min_lower = 1
  min_upper = 1
}


locals {
  dns_label_prefix          = "${var.resource_prefix}-postgresql"
  connection_string         = "postgresql://${local.postgresql_admin_username}@${azurerm_postgresql_database.demo.server_name}:${local.postgresql_admin_password}@${azurerm_private_endpoint.demo.private_service_connection.0.private_ip_address}:5432/${local.postgresql_db_name}"
  linux_fx_version          = "DOCKER|${var.container_registry_server}/${var.container_image_name}"
  container_registry_server = "https://${var.container_registry_server}"
  postgresql_admin_username = var.postgresql_admin_username == "" ? random_string.pgs-username.result : var.postgresql_admin_username
  postgresql_admin_password = var.postgresql_admin_password == "" ? random_string.pgs-password.result : var.postgresql_admin_password
  postgresql_db_name        = var.db_name == "" ? "${random_string.pgs-db-name.result}-demo-api" : var.db_name
}

data "azurerm_client_config" "current" {}

# Api VNet
resource "azurerm_virtual_network" "demo" {
  name                = "${local.dns_label_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Integration subnet
resource "azurerm_subnet" "demo_is" {
  name                 = "${local.dns_label_prefix}-integration-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.demo.name
  resource_group_name  = var.resource_group_name
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]

    }
  }
}

# Endpoint subnet
resource "azurerm_subnet" "demo" {
  name                                           = "${local.dns_label_prefix}-endpoint-subnet"
  address_prefixes                               = ["10.0.2.0/24"]
  virtual_network_name                           = azurerm_virtual_network.demo.name
  resource_group_name                            = var.resource_group_name
  enforce_private_link_endpoint_network_policies = true
}

# Postgresql Server
resource "azurerm_postgresql_server" "demo" {
  name                = "${var.resource_prefix}-postgresql"
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login          = local.postgresql_admin_username
  administrator_login_password = local.postgresql_admin_password

  sku_name = "GP_Gen5_2"
  version  = "11"

  storage_mb        = var.postgresql_storage
  auto_grow_enabled = true

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Postgresql database
resource "azurerm_postgresql_database" "demo" {
  depends_on          = [azurerm_postgresql_server.demo]
  name                = local.postgresql_db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.demo.name
  charset             = "UTF8"
  collation           = "en-US"
}

# Postgresql private endpoint 
resource "azurerm_private_endpoint" "demo" {
  name                = "${var.resource_prefix}-pgs-server-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.demo.id

  private_service_connection {
    name                           = "${var.resource_prefix}-private-service-connection"
    private_connection_resource_id = azurerm_postgresql_server.demo.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

# App service plan
resource "azurerm_app_service_plan" "demo" {
  name                = "${var.resource_prefix}-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

# We grant access to keyvault to App Service
resource "azurerm_key_vault_access_policy" "demo" {
  key_vault_id = var.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.demo.identity.0.principal_id

  secret_permissions = [
    "get", "set", "list", "delete", "purge"
  ]
}

# Add KeyVault entries
locals {
  kv_entries = {
    "acr-username"         = var.container_registry_username
    "acr-password"         = var.container_registry_password
    "db-connection-string" = local.connection_string
    "db-username"          = local.postgresql_admin_username
    "db-password"          = local.postgresql_admin_password
  }
}

resource "azurerm_key_vault_secret" "demo" {
  for_each     = local.kv_entries
  key_vault_id = var.keyvault_id
  name         = each.key
  value        = each.value
}

# App service  
resource "azurerm_app_service" "demo" {
  name                = "${var.resource_prefix}-api"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.demo.id
  site_config {
    linux_fx_version = local.linux_fx_version
    always_on        = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    WEBSITE_ENABLE_SYNC_UPDATE_SITE     = "true"
    DOCKER_REGISTRY_SERVER_URL          = local.container_registry_server
    DOCKER_REGISTRY_SERVER_USERNAME     = "@Microsoft.KeyVault(SecretUri=${var.keyvault_uri}secrets/acr-username)"
    DOCKER_REGISTRY_SERVER_PASSWORD     = "@Microsoft.KeyVault(SecretUri=${var.keyvault_uri}secrets/acr-password)"
    SQL_DATABASE_URI                    = "@Microsoft.KeyVault(SecretUri=${var.keyvault_uri}secrets/db-connection-string)"
    WEBSITES_PORT                       = 80
    KEY_VAULT_URL                       = var.keyvault_uri
  }

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled                       = true
    default_provider              = "AzureActiveDirectory"
    unauthenticated_client_action = "RedirectToLoginPage"

    active_directory {
      client_id = var.ad_application_id
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "demo" {
  app_service_id = azurerm_app_service.demo.id
  subnet_id      = azurerm_subnet.demo_is.id
}
