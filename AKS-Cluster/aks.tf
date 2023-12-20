# main.tf

provider "azurerm" {
    features {
      subscription {
        
      }
    }
}

resource "azurerm_resource_group" "aks" {
  name     = "my-aks-resource-group"
  location = "East US"  # Change to your desired Azure region
}

module "aks" {
  source  = "terraform-azurerm-modules/aks/azurerm"
  version = "~> 4.0.0"

  resource_group_name = azurerm_resource_group.aks.name
  cluster_name        = "my-aks-cluster"

  agent_pools = {
    default = {
      name            = "agentpool"
      vm_size         = "Standard_DS2_v2"  # Change to your desired VM size
      node_count      = 1
      enable_auto_scaling = true
      min_count       = 1
      max_count       = 3
    }
  }
}

module "mysql" {
  source  = "terraform-azurerm-modules/mysql/azurerm"
  version = "~> 2.0.0"

  resource_group_name  = azurerm_resource_group.aks.name
  server_name          = "mysql-server"
  admin_username       = "adminuser"
  admin_password       = "SuperSecretPassword123!"  # Change to a strong password
  sku_tier             = "GeneralPurpose"
  sku_capacity         = 2
}

module "acr" {
  source  = "terraform-azurerm-modules/acr/azurerm"
  version = "~> 3.0.0"

  resource_group_name = azurerm_resource_group.aks.name
  acr_name            = "myacr"
}

module "wordpress" {
  source  = "terraform-azurerm-modules/kubernetes/azurerm"
  version = "~> 3.0.0"

  resource_group_name = azurerm_resource_group.aks.name
  cluster_name        = module.aks.cluster_name

  acr_server          = module.acr.login_server
  acr_username        = module.acr.admin_username
  acr_password        = module.acr.admin_password

  mysql_host          = module.mysql.hostname
  mysql_database      = "wordpress"
  mysql_username      = module.mysql.username
  mysql_password      = module.mysql.password
}

output "aks_kube_config" {
  value = module.aks.kube_config
}

output "wordpress_url" {
  value = module.wordpress.wordpress_url
}
