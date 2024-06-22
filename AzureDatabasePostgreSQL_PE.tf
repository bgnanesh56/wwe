resource "azurerm_postgresql_server" "postgresql" {
  name                = "myPostgresqlServer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name                     = "B_Gen5_1"
  storage_mb                   = 5120
  administrator_login          = "adminuser"
  administrator_login_password = "adminpassword"
  version                      = "11"
}

resource "azurerm_private_endpoint" "postgresql_private_endpoint" {
  name                = "postgresqlPrivateEndpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "postgresqlConnection"
    private_connection_resource_id = azurerm_postgresql_server.postgresql.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

