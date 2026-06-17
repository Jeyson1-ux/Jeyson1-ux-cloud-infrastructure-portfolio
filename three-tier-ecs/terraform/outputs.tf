output "aws_dns_name" {
  value       = aws_lb.main.dns_name
  description = "DNS name"
}

output "aws_frontend_service" {
  value       = aws_ecs_service.frontend.name
  description = "ECS frontend service name"
}

output "aws_backend_service" {
  value       = aws_ecs_service.backend.name
  description = "ECS backend service name"
}

output "aws_rds_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "Get the RDS endpoint"
}