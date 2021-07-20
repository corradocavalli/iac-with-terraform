output "keyvault_id" {
  value = azurerm_key_vault.demo.id
}

output "keyvault_uri" {
  value = azurerm_key_vault.demo.vault_uri
}
