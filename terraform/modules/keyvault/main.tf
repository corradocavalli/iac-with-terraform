data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo" {
  name                        = "${var.resource_prefix}-keyvault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}

# Grant key vault access to current terraform user
resource "azurerm_key_vault_access_policy" "demo" {
  key_vault_id = azurerm_key_vault.demo.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "get", "set", "list", "delete", "purge"
  ]
}
