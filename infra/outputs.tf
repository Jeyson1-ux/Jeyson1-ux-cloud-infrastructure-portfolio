output "ecr_repository_url" {
  value       = aws_ecr_repository.app.repository_url # full ECR URL
  description = "ECR repository URL for the Docker images"
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "DNS name"
}

output "app_url" {
  value       = "https://app.devvie.se"
  description = "App URL"

}