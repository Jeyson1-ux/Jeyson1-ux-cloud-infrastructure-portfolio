resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "aws-vpc"
  }

}

resource "aws_subnet" "main" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "aws-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count  = var.need_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.subnet_cidrs)) : 0
  domain = "vpc" // This is required to create a NAT Gateway in a VPC
}

# condition ? value_if_true : value_if_false

resource "aws_nat_gateway" "main" {
  count         = var.need_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.subnet_cidrs)) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.single_nat_gateway ? aws_subnet.main[0].id : aws_subnet.main[count.index].id
}

output "ecs_services" {
  value       = local.ecs_services
  description = "List of the ECS services to be created."
}