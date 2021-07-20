variable "resource_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_registry_server" {
  type        = string
  description = "ACR name"
}

variable "container_registry_username" {
  type        = string
  description = "ACR username"
}

variable "container_registry_password" {
  type        = string
  description = "ACR password"
}

variable "container_image_name" {
  type        = string
  description = "Container image name"
}
variable "db_name" {
  type    = string
  default = ""
}

variable "postgresql_admin_username" {
  type        = string
  description = "Login to authenticate to PostgreSQL Server"
  sensitive   = true
}
variable "postgresql_admin_password" {
  type        = string
  description = "Password to authenticate to PostgreSQL Server"
  sensitive   = true
}

variable "postgresql_storage" {
  type        = string
  description = "PostgreSQL Storage in MB"
}

variable "keyvault_id" {
  type        = string
  description = "Id of they keyvault"
}

variable "keyvault_uri" {
  type        = string
  description = "Id of they keyvault"
}

variable "app_service_name" {
  type        = string
  description = "Name of the app service"
}

variable "ad_application_id" {
  type        = string
  description = "AD application id"
}
