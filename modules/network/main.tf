# Fetch the list of available AZs in the region
data "aws_availability_zones" "available" {}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

# Generate a random sequence for private subnets
resource "random_shuffle" "private_az" {
  input        = data.aws_availability_zones.available.names
  result_count = length(var.private_subnets)
}

# Create a local map of public subnets to AZs
locals {
  private_subnet_to_az = { for i, cidr in var.private_subnets : cidr => random_shuffle.private_az.result[i] }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each                = toset(var.private_subnets)
  availability_zone       = local.private_subnet_to_az[each.key]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${replace(each.value, ".", "-")}"
  }
  lifecycle {
    ignore_changes = [availability_zone]
  }
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.private)[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = values(aws_subnet.private)[count.index].id
  route_table_id = aws_route_table.private.id
}

# Generate a random sequence for public subnets
resource "random_shuffle" "public_az" {
  input        = data.aws_availability_zones.available.names
  result_count = length(var.public_subnets)
}

# Create a local map of public subnets to AZs
locals {
  public_subnet_to_az = { for i, cidr in var.public_subnets : cidr => random_shuffle.public_az.result[i] }
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnets)
  availability_zone       = local.public_subnet_to_az[each.key]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${replace(each.value, ".", "-")}"
  }
  lifecycle {
    ignore_changes = [availability_zone]
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = values(aws_subnet.public)[count.index].id
  route_table_id = aws_route_table.public.id
}
