terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  backend "azurerm" {
    storage_account_name     = "<YourAzureStorageAccountName>"
    container_name           = "tfstate-app"
    key                      = "terraform.tfstate"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/aksconfig"
}
resource "kubernetes_namespace" "test" {
  metadata {
    name = "wordpress"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}