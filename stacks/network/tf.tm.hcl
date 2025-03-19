generate_hcl "network.tf" {
  content {
    # Alert for high response times on Application Gateway
    resource "azurerm_monitor_metric_alert" "app_gw_latency" {
      name                = "AppGW-High-Latency"
      resource_group_name = var.resource_group_name
      scopes              = [azurerm_application_gateway.app_gw.id]
      description         = "Alerts when Application Gateway response time is high"

      criteria {
        metric_namespace = "Microsoft.Network/applicationGateways"
        metric_name      = "ResponseLatency"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 500 # 500ms threshold
      }

      action {
        action_group_id = azurerm_monitor_action_group.alert_action_group.id
      }
    }

    # Create an Action Group for Alerts
    resource "azurerm_monitor_action_group" "alert_action_group" {
      name                = "AppAlerts"
      resource_group_name = var.resource_group_name
      short_name          = "AppAlerts"

      email_receiver {
        name          = "admin"
        email_address = "admin@example.com"
      }
    }
  }
}