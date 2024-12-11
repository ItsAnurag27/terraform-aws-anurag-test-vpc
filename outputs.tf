
# Output for VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

# Output for Public Subnets
output "public_subnet" {
  value = {
    for key, config in local.public_subnet : key => {
      subnet_id      = aws_subnet.main[key].id
      availability_zone = aws_subnet.main[key].availability_zone
    }
  }
  description = "Details of the public subnets including subnet_id and availability_zone"
}

# Output for Private Subnets
output "private_subnet" {
  value = {
    for key, config in var.subnet_config : key => {
      subnet_id      = aws_subnet.main[key].id
      availability_zone = aws_subnet.main[key].availability_zone
    }
  }
  description = "Details of the private subnets including subnet_id and availability_zone"
}
