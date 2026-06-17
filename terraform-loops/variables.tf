variable "subnet_cidrs" {
  description = "List of the subnet CIDRs blocks to create."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  description = "List of the availability zones to create."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "need_nat_gateway" {
  description = "Whether to create a Nat Gateway or not"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Whether we shall create a single nat gateway, (one for each subnet or not)"
  type        = bool
  default     = true
}