resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "myaks"
  kubernetes_version  = "1.21.2"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "np" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
}

resource "azurerm_container_app_environment" "env" {
  name                = "exampleenv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
}

resource "azurerm_container_app" "app" {
  name                = "exampleapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  container_app_environment_id = azurerm_container_app_environment.env.id
  dapr_enabled                 = true

  configuration {
    ingress {
      external_enabled = true
      target_port      = 80
    }
  }

  container {
    name   = "examplecontainer"
    image  = "nginx:latest"
    cpu    = 0.5
    memory = "1Gi"
  }
}
