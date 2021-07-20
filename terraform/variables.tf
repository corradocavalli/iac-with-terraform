variable "resource_group_location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Pre-existing resource group that will be used for provisioning the infastructure"
  default     = "my-existing-resource-group"
}

variable "create_resource_group" {
  type    = bool
  default = false
}

variable "container_image_name" {
  type        = string
  default     = "webapi-demo"
  description = "Optional container image name"
}

variable "db_name" {
  type        = string
  description = "Optional name of API related database"
  default     = "api-db"
}

variable "postgresql_admin_username" {
  type        = string
  description = "Login to authenticate to PostgreSQL Server"
  default     = ""
}
variable "postgresql_admin_password" {
  type        = string
  description = "Password to authenticate to PostgreSQL Server"
  default     = ""
  sensitive   = true
}

variable "postgresql_storage" {
  type        = string
  description = "PostgreSQL Storage in MB"
  default     = 5120
}