generate_hcl "containers.tf" {
  content {
    resource "azurerm_container_app_environment" "container_env" {
      name                     = var.container_env_name
      location                 = var.location
      resource_group_name      = var.resource_group_name
      infrastructure_subnet_id = azurerm_subnet.container_subnet.id
      internal_only            = true
    }

    resource "azurerm_container_app" "web_frontend" {
      name                         = "web-frontend"
      resource_group_name          = var.resource_group_name
      container_app_environment_id = azurerm_container_app_environment.container_env.id

      ingress {
        external_enabled = false
        target_port      = 80
        transport        = "http"
      }

      template {
        container {
          name   = "web"
          image  = "yourcontainerregistry.azurecr.io/web-frontend:latest"
          cpu    = 0.5
          memory = "1Gi"
        }
      }
    }

    resource "azurerm_container_app" "api_backend" {
      name                         = "api-backend"
      resource_group_name          = var.resource_group_name
      container_app_environment_id = azurerm_container_app_environment.container_env.id

      ingress {
        external_enabled = false
        target_port      = 8080
        transport        = "http"
      }

      template {
        container {
          name   = "api"
          image  = "yourcontainerregistry.azurecr.io/api-backend:latest"
          cpu    = 0.5
          memory = "1Gi"
        }
      }
    }
  }
}