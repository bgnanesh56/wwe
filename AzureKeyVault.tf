resource "azurerm_key_vault" "key_vault" {
  name                = "myKeyVault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_enabled = true
}

resource "azurerm_key_vault_secret" "example_secret" {
  name         = "exampleSecret"
  value        = "MySecretValue"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_certificate" "example_cert" {
  name         = "exampleCert"
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate {
    contents = filebase64("path/to/your/certificate.pfx")
  }
}
