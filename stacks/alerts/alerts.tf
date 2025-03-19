// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "azurerm_monitor_metric_alert" "app_gw_latency" {
  description         = "Alerts when Application Gateway response time is high"
  name                = "AppGW-High-Latency"
  resource_group_name = var.resource_group_name
  scopes = [
    azurerm_application_gateway.app_gw.id,
  ]
  criteria {
    aggregation      = "Average"
    metric_name      = "ResponseLatency"
    metric_namespace = "Microsoft.Network/applicationGateways"
    operator         = "GreaterThan"
    threshold        = 500
  }
  action {
    action_group_id = azurerm_monitor_action_group.alert_action_group.id
  }
}
resource "azurerm_monitor_action_group" "alert_action_group" {
  name                = "AppAlerts"
  resource_group_name = var.resource_group_name
  short_name          = "AppAlerts"
  email_receiver {
    email_address = "admin@example.com"
    name          = "admin"
  }
}
