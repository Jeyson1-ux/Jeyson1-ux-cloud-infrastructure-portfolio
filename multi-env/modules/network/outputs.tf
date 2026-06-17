output "vpc_id" {
    description = "Retrieving the id of the VPC that we have created in the network module"
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    description = "Retrieving the public subnet ids that we created in the network module"
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    description = "Retrieving the private subnet ids that we created in the network module"
    value = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
    description = "Retrieving the nat gateway ids that we created in the network module"
    value = aws_nat_gateway.main[*].id
}

output "internet_gateway_ids" {
    description = "Retrieving the internet gateway ids that we created in the network module"
    value = aws_internet_gateway.main.id
}


