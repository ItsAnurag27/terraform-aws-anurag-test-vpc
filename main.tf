provider "aws" {
  region = "eu-north-1"
}

# VPC Resource
resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

# Subnet Resources
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  for_each = var.subnet_config
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    Name = each.key
  }
}

# Filter Public Subnets from All Subnets
locals {
  public_subnet = {
    for key, config in var.subnet_config : key => config if config.public
  }
}

# Internet Gateway (only if there are public subnets)
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_subnet) > 0 ? 1 : 0
}

# Routing Table (only if there are public subnets)
resource "aws_route_table" "table" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_subnet) > 0 ? 1 : 0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = length(aws_internet_gateway.gateway) > 0 ? aws_internet_gateway.gateway[0].id : null
  }
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "asso" {
  for_each = local.public_subnet
  subnet_id = aws_subnet.main[each.key].id
  route_table_id = length(aws_route_table.table) > 0 ? aws_route_table.table[0].id : null
}
