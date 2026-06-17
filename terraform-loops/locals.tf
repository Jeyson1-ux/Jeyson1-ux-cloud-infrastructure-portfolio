locals {
  ecs_services = [
    {
      name        = "frontend",
      image       = "nginx:latest"
      port        = 80
      environment = "dev"
    },
    {
      name        = "backend",
      image       = "python:3.11"
      port        = 8000
      environment = "dev"
    }
  ]
}