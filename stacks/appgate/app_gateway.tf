// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "azurerm_public_ip" "app_gw_ip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "app-gw-ip"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}
resource "azurerm_application_gateway" "app_gw" {
  location            = var.location
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
  autoscale_configuration {
    max_capacity = 3
    min_capacity = 1
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
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    name                           = "web-listener"
    protocol                       = "Http"
  }
  request_routing_rule {
    backend_address_pool_name  = "web-backend-pool"
    backend_http_settings_name = "http-settings"
    http_listener_name         = "web-listener"
    name                       = "web-rule"
    rule_type                  = "Basic"
  }
  backend_address_pool {
    name = "web-backend-pool"
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = "http-settings"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }
}
