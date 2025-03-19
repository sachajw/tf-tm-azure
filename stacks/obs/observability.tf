// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "azurerm_log_analytics_workspace" "log_analytics" {
  location            = var.location
  name                = "log-analytics-ws"
  resource_group_name = var.resource_group_name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
resource "azurerm_monitor_diagnostic_setting" "app_gw_diag" {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  name                       = "app-gw-diag"
  target_resource_id         = azurerm_application_gateway.app_gw.id
  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true
  }
  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = true
  }
  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
resource "azurerm_monitor_diagnostic_setting" "container_diag" {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  name                       = "container-diag"
  target_resource_id         = azurerm_container_app_environment.container_env.id
  log {
    category = "AppLogs"
    enabled  = true
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
