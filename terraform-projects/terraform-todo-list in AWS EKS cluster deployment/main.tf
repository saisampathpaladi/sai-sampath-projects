resource "kubernetes_deployment" "todo-app" {
  metadata {
    name      = "todo-app"
    namespace = "default"
    labels = {
      app = "todo-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "todo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "todo-app"
        }
      }

      spec {
        container {
          name  = "todo-app"
          image = "sampathsai/todo-app:latest" 
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "todo-app" {
  metadata {
    name      = "todo-app"
    namespace = "default"
  }

  spec {
    selector = {
      app = "todo-app"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }
  }
}
