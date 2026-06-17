region = "ap-south-1"
vpc_cidr = "10.1.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
name_prefix = "bootcamp-assignment5-prod"
private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
public_subnet_cidrs = ["10.1.3.0/24","10.1.4.0/24"]
need_nat_gateway = true
single_nat_gateway = false
