#Providers
provider "azurerm" {
  features {}
}

#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "West Europe"
}

