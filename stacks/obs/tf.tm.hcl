generate_hcl "observability.tf" {
  content {
    # Create a Log Analytics Workspace
    resource "azurerm_log_analytics_workspace" "log_analytics" {
      name                = "log-analytics-ws"
      location            = var.location
      resource_group_name = var.resource_group_name
      sku                 = "PerGB2018"
      retention_in_days   = 30
    }

    # Enable diagnostics for Application Gateway
    resource "azurerm_monitor_diagnostic_setting" "app_gw_diag" {
      name                       = "app-gw-diag"
      target_resource_id         = azurerm_application_gateway.app_gw.id
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

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

    # Enable diagnostics for Container Apps
    resource "azurerm_monitor_diagnostic_setting" "container_diag" {
      name                       = "container-diag"
      target_resource_id         = azurerm_container_app_environment.container_env.id
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

      log {
        category = "AppLogs"
        enabled  = true
      }

      metric {
        category = "AllMetrics"
        enabled  = true
      }
    }
  }
}