output "api_url" {
  description = "Url of web api"
  value       = azurerm_app_service.demo.default_site_hostname
}
