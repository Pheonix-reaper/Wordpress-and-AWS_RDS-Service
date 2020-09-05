provider "kubernetes" {
 config_context_cluster = "minikube"
}

resource "null_resource" "minikube" {
 provisioner "local-exec" {
      command = "minikube start"
   }
}

resource "kubernetes_deployment" "wordpress" {
 metadata {
  name = "wordpress"
 }
 spec {
  replicas = 1
  selector {
   match_labels = {
    env = "production"
    region = "IN"
    App = "wordpress"
   }
  match_expressions {
   key = "env"
   operator = "In"
   values = ["production" , "webserver"]
  }
 }
 template {
  metadata {
   labels = {
    env = "production"
    region = "IN"
    App = "wordpress"
   }
  }
  spec {
   container {
    image = "wordpress:4.8-apache"
    name = "wp" 
    }
   }
  }
 }
}




resource "kubernetes_service" "mywordpress" {
 metadata {
  name = "mywordpress"
 }
 spec {
  selector = {
   App = "wordpress"
  }
  port {
   node_port   = 31000
   port = 80
   target_port = 80
  }
  type = "NodePort"
 }
}
