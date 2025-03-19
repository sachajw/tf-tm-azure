generate_hcl "app_gateway.tf" {
  content {
    resource "azurerm_public_ip" "app_gw_ip" {
      name                = "app-gw-ip"
      location            = var.location
      resource_group_name = var.resource_group_name
      allocation_method   = "Static"
      sku                 = "Standard"
    }

    resource "azurerm_application_gateway" "app_gw" {
      name                = var.app_gateway_name
      location            = var.location
      resource_group_name = var.resource_group_name

      sku {
        name = "WAF_v2"
        tier = "WAF_v2"
      }

      autoscale_configuration {
        min_capacity = 1
        max_capacity = 3
      }

      gateway_ip_configuration {
        name      = "app-gw-ip-config"
        subnet_id = azurerm_subnet.app_gw_subnet.id
      }

      frontend_ip_configuration {
        name                 = "frontend-ip"
        public_ip_address_id = azurerm_public_ip.app_gw_ip.id
      }

      frontend_port {
        name = "http-port"
        port = 80
      }

      http_listener {
        name                           = "web-listener"
        frontend_ip_configuration_name = "frontend-ip"
        frontend_port_name             = "http-port"
        protocol                       = "Http"
      }

      request_routing_rule {
        name                       = "web-rule"
        rule_type                  = "Basic"
        http_listener_name         = "web-listener"
        backend_address_pool_name  = "web-backend-pool"
        backend_http_settings_name = "http-settings"
      }

      backend_address_pool {
        name = "web-backend-pool"
      }

      backend_http_settings {
        name                  = "http-settings"
        cookie_based_affinity = "Disabled"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 20
      }
    }
  }
}