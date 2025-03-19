// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "azurerm_container_app_environment" "container_env" {
  infrastructure_subnet_id = azurerm_subnet.container_subnet.id
  internal_only            = true
  location                 = var.location
  name                     = var.container_env_name
  resource_group_name      = var.resource_group_name
}
resource "azurerm_container_app" "web_frontend" {
  container_app_environment_id = azurerm_container_app_environment.container_env.id
  name                         = "web-frontend"
  resource_group_name          = var.resource_group_name
  ingress {
    external_enabled = false
    target_port      = 80
    transport        = "http"
  }
  template {
    container {
      cpu    = 0.5
      image  = "yourcontainerregistry.azurecr.io/web-frontend:latest"
      memory = "1Gi"
      name   = "web"
    }
  }
}
resource "azurerm_container_app" "api_backend" {
  container_app_environment_id = azurerm_container_app_environment.container_env.id
  name                         = "api-backend"
  resource_group_name          = var.resource_group_name
  ingress {
    external_enabled = false
    target_port      = 8080
    transport        = "http"
  }
  template {
    container {
      cpu    = 0.5
      image  = "yourcontainerregistry.azurecr.io/api-backend:latest"
      memory = "1Gi"
      name   = "api"
    }
  }
}
