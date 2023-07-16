terraform {
  cloud {
    organization = "sudomateo"

    workspaces {
      name = "taskly"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.1"
    }
  }
}

provider "digitalocean" {}

variable "frontend_tag" {
  type        = string
  description = "Container image tag of the frontend image."
}

variable "backend_tag" {
  type        = string
  description = "Container image tag of the backend image."
}

resource "digitalocean_app" "taskly" {
  spec {
    name   = "taskly"
    region = "nyc3"

    service {
      name = "frontend"

      instance_count = 1
      http_port      = 80

      image {
        registry_type = "DOCKER_HUB"
        registry      = "sudomateo"
        repository    = "taskly-frontend"
        tag           = var.frontend_tag
      }

      routes {
        path                 = "/"
        preserve_path_prefix = true
      }

      health_check {
        http_path = "/"
      }
    }

    service {
      name = "backend"

      instance_count = 1
      http_port      = 3030

      image {
        registry_type = "DOCKER_HUB"
        registry      = "sudomateo"
        repository    = "taskly-backend"
        tag           = var.backend_tag
      }

      routes {
        path                 = "/api"
        preserve_path_prefix = true
      }

      health_check {
        http_path = "/api/health"
      }
    }
  }
}

output "url" {
  value = digitalocean_app.taskly.live_url
}
