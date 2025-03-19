generate_hcl "private_link.tf" {
  content {
    # Create a Private DNS Zone for SQL Server
    resource "azurerm_private_dns_zone" "sql_dns" {
      name                = "privatelink.database.windows.net"
      resource_group_name = var.resource_group_name
    }

    # Link Private DNS Zone to VNet
    resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
      name                  = "sql-dns-link"
      resource_group_name   = var.resource_group_name
      private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
      virtual_network_id    = azurerm_virtual_network.vnet.id
    }

    # Create a Private Endpoint for SQL Server
    resource "azurerm_private_endpoint" "sql_private_endpoint" {
      name                = "sql-private-endpoint"
      location            = var.location
      resource_group_name = var.resource_group_name
      subnet_id           = azurerm_subnet.sql_subnet.id

      private_service_connection {
        name                           = "sql-private-connection"
        private_connection_resource_id = "/subscriptions/YOUR_SUB_ID/resourceGroups/YOUR_RG/providers/Microsoft.Sql/servers/YOUR_SQL_SERVER"
        subresource_names              = ["sqlServer"]
        is_manual_connection           = false
      }

      private_dns_zone_group {
        name                 = "sql-dns-group"
        private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
      }
    }
  }
}