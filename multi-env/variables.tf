variable "vpc_cidr" {
    description = "Declaration of the vpc CIDR block"
    type = string
    default  = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "Declaration of the public subnet CIDR blocks"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
    description = "Declaration of the private subnet CIDR blocks"
    type = list(string)
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
    description = "Declaration of the availability zones for our system"
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "name_prefix" {
    description = "Declaration of the name prefix for all the different resources"
    type = string
    default = "bootcamp-assignment5"
}

variable "need_nat_gateway" {
    description = "Declaration of whether we should use a single nat gateway or not"
    type = bool
    default = true
}

variable "single_nat_gateway" {
    description = "Use a single nat gateway for all provate subnets instead of one per subnet"
    type = bool
    default = true
}

variable "region" {
    description = "Declaration of the region we are hosting our infrastructure in."
    type = string
    default = "ap-south-1a"
}