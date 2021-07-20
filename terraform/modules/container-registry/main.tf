resource "azurerm_container_registry" "demo" {
  name                = "${var.resource_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}