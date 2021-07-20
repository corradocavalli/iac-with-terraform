output "db_server" {
  description = "Postgresql server name"
  value       = azurerm_postgresql_database.demo.server_name
}
output "db_name" {
  description = "Postgresql database name"
  value       = azurerm_postgresql_database.demo.name
}

output "postgresql_admin_username" {
  value = local.postgresql_admin_username
}

output "postgresql_admin_password" {
  value     = local.postgresql_admin_password
  sensitive = true
}

output "api_url" {
  description = "Url of web api"
  value       = azurerm_app_service.demo.default_site_hostname
}

output "appservice_name" {
  description = "AppService name"
  value       = azurerm_app_service.demo.name
}
