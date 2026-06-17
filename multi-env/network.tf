module "network" {
    source = "./modules/network"
    
    vpc_cidr = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    availability_zones = var.availability_zones
    name_prefix = var.name_prefix
    need_nat_gateway = var.need_nat_gateway
    single_nat_gateway = var.single_nat_gateway

}