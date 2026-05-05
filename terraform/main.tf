terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# 1. Create Networks
resource "docker_network" "east_network" { name = "east-network" }
resource "docker_network" "west_network" { name = "west-network" }
resource "docker_network" "private_network" { name = "ecommerce-network" }

# 2. Build Images
resource "docker_image" "ecommerce_backend" {
  name = "ecommerce-backend:latest"
  build { context = "../backend" }
}

resource "docker_image" "frontend_image" {
  name = "ecommerce-frontend:latest"
  build { context = "../frontend" }
}

# 3. Deploy Backend Nodes
resource "docker_container" "east_node" {
  count = 2
  image = docker_image.ecommerce_backend.image_id
  name  = "east-node-${count.index + 1}"
  env   = ["REGION=US-East"]
  networks_advanced { name = docker_network.east_network.name }
  networks_advanced { name = docker_network.private_network.name }
}

resource "docker_container" "west_node" {
  count = 2
  image = docker_image.ecommerce_backend.image_id
  name  = "west-node-${count.index + 1}"
  env   = ["REGION=US-West"]
  networks_advanced { name = docker_network.west_network.name }
  networks_advanced { name = docker_network.private_network.name }
}

# 4. Deploy Databases
resource "docker_container" "postgres_primary" {
  image = "postgres:15-alpine"
  name  = "postgres-primary"
  env   = ["POSTGRES_PASSWORD=securepassword"]
  networks_advanced { name = docker_network.east_network.name }
  networks_advanced { name = docker_network.private_network.name }
}

resource "docker_container" "postgres_replica" {
  image = "postgres:15-alpine"
  name  = "postgres-replica"
  env   = ["POSTGRES_PASSWORD=securepassword"]
  networks_advanced { name = docker_network.west_network.name }
  networks_advanced { name = docker_network.private_network.name }
}

# 5. Deploy Frontend
resource "docker_container" "frontend_container" {
  image = docker_image.frontend_image.image_id
  name  = "frontend"
  ports {
    internal = 80
    external = 3001
  }
  networks_advanced { name = docker_network.private_network.name }
}

# 6. Deploy Load Balancer
# 6. Deploy Load Balancer
# 6. Deploy Load Balancer
resource "docker_container" "load_balancer" {
  image = "nginx:alpine"
  name  = "load-balancer"

  ports {
    internal = 80
    external = 8080 
  }

  # THIS IS THE MISSING PIECE
  networks_advanced {
    name = docker_network.private_network.name # Must match your backend network name
  }

  volumes {
    host_path      = "${abspath(path.module)}/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
    read_only      = true
  }

  depends_on = [
    docker_container.east_node,
    docker_container.west_node
  ]
}