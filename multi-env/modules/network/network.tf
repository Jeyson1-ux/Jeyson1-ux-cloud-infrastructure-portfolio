resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.name_prefix}-vpc"
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.name_prefix}-igw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.name_prefix}-public-rt"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.name_prefix}-private-rt"
    }
}

resource "aws_eip" "nat" {
    count = var.need_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0 // we want to create as many elastic ips as the number of nat gateways that we want to create
    domain = "vpc" // this means that the elastic ip will be used for a nat gateway and not for an instance

    tags = {
        Name = "${var.name_prefix}-nat-eip.${count.index + 1}"
    }
}

resource "aws_nat_gateway" "main" {
    count = var.need_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
    allocation_id = aws_eip.nat[count.index].id // allocation id = the id of the elastic ip that we created for the nat gateway
    subnet_id = aws_subnet.public[count.index].id // subnet id = the id of the public subnet in which we want to place the nat gateway

    tags = {
        Name = "${var.name_prefix}-nat-gateway-count.${count.index + 1}"
    }
}

resource "aws_route" "public_internet_access" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0" // this means that this route will be used for all the traffic that is going outside the vpc
    gateway_id = aws_internet_gateway.main.id
    depends_on = [aws_internet_gateway.main] // ensures that the route is created only after the internet gateway is created'

}

resource "aws_route" "private_internet_access" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0" // this means that this route will be used for all the traffic that is going outside the vpc
    nat_gateway_id = var.need_nat_gateway ? aws_nat_gateway.main[0].id : null
    depends_on = [aws_internet_gateway.main] // ensures that the route is created only after the internet gateway is created'
    
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs) // route table association = the number of public subnets that we have
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs) // we want to create as many route table associations as the number of private subnets we have
    route_table_id = aws_route_table.private.id // the route table id = the id of the private route table that we created
    subnet_id = aws_subnet.private[count.index].id // the subnet id = the id of the private subnet that we created
}