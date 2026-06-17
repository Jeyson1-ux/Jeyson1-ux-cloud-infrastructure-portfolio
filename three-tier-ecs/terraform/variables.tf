
variable "region" {
  description = "Declaration of the region for our infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "Declaration of the vpc cidr block for our infrastructure"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Declare our base project name that every resource will have attached to it"
  type        = string
  default     = "bootcamp-3tier-ecs"
}

variable "public_subnet_cidrs" {
  description = "Declaration of the public subnet cidrs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_subnet_cidrs" {
  description = "Declaration of the private subnet cidrs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "environment" {
  description = "Declare the environment of our system - deployment environment"
  type        = string
  default     = "dev"
}


variable "db_subnet_cidrs" {
  description = "Declare the subnet cidrs for the db"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "Declare the availability zones for the db"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "db_name" {
  description = "Declare the db name"
  type        = string
  default     = "threetierdb"
}

variable "db_username" {
  description = "Declare the db username"
  type        = string
  default     = "postgres"
}

variable "frontend_image" {
  description = "Declare the frontend image"
  type        = string
  default     = ""
}

variable "backend_image" {
  description = "Declare the frontend image"
  type        = string
  default     = ""
}