variable "region" {
  description = "Declaration of the aws region used"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "Declaration of the vpc cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Declaration of the public subnet cidr"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Declaration of the private subnet cidr"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "db_subnet_cidrs" {
  description = "The declaration of the subnet cidrs for the db"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "availability_zones" {
  description = "Declare the AZs so if one zone goes down, the app keeps running on the other"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "project_name" {
  description = "Define the name of the project"
  type        = string
  default     = "bootcamp-ecs-3tasks"
}