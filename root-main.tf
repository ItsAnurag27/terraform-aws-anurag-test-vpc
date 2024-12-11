provider "aws" {
  region  = "eu-north-1"
  profile = "admin"  # Replace with your AWS CLI profile if needed
}

module "vpc" {
  source = "./module_vpc"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-test-vpc"
  }
}
