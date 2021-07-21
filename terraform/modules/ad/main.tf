data "azuread_client_config" "current" {}

resource "azuread_application" "demo" {
  display_name     = "${var.resource_prefix}-api-auth"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {

    oauth2_permission_scope {
      id                         = "96183846-204b-1366-82e1-5d2222eb4b9b" 
      admin_consent_description  = "Allow the application to access API on behalf of the signed-in user."
      admin_consent_display_name = "Access API"
      enabled                    = true
      type                       = "User"
      user_consent_description   = "Allow the application to access API on your behalf."
      user_consent_display_name  = "Access API"
      value                      = "user_impersonation"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" #This is the ID of MS Graph app.
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" #This is the id of "User.Read" scope.
      type = "Scope"
    }
  }

  web {
    redirect_uris = ["https://${var.app_service_name}.azurewebsites.net/.auth/login/aad/callback"]
    implicit_grant {
      access_token_issuance_enabled = true
    }
  }
}

resource "azuread_application_password" "demo" {
  application_object_id = azuread_application.demo.id
}

#We store info into key vault for convenience
resource "azurerm_key_vault_secret" "api-client-id" {
  key_vault_id = var.keyvault_id
  name         = "api-client-id"
  value        = azuread_application.demo.application_id
}

resource "azurerm_key_vault_secret" "api-client-secret" {
  key_vault_id = var.keyvault_id
  name         = "api-client-secret"
  value        = azuread_application_password.demo.value
}
