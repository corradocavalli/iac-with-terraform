output "resource_group_name" {
  value       = local.resource_group_name
  description = "The resource group where resources have been created"
}

output "api_url" {
  value       = module.api.api_url
  description = "API endpoint address"
}

output "acr_url" {
  value       = module.acr.container_registry_server
  description = "Azure container registry url"
}

output "ad_app_registration_id" {
  value       = module.ad.application_id
  description = "The AD app registration id"
}






