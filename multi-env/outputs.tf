output "vpc_id" {
    description = "The VPC ID."
    value = module.network.vpc_id
}

output "public_subnet_ids" {
    description = "Retrieving the public subnets of our infrastructure."
    value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
    description = "Retrieving the private subnets of our infrastructure."
    value = module.network.private_subnet_ids
}

output "nat_gateway_ids" {
    description = "Retrieving the NAT gateway id for our system."
    value = module.network.nat_gateway_ids
}