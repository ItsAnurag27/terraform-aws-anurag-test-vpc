variable "vpc_config" {
  description = "to get the CIDR and name of the users"
  type = object({
    cidr_block = string
    name       = string
  })
  default = {
    cidr_block = "10.0.0.0/16"
    name       = "my-default-vpc"
  }

  validation {
    condition = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_config.cidr_block))
    error_message = "invalid CIDR format"
  }
}

variable "subnet_config" {
  description = "get the cidr and az for the subnets"
  type = map(object({
    cidr_block = string
    az         = string
    public = optional(bool , false)
  }))
  default = {
    public_subnet = {
      cidr_block = "10.0.0.0/24"
      az         = "eu-north-1a"
      public =true
    },
    public_subnet = {
      cidr_block = "10.0.3.0/24"
      az         = "eu-north-1c"
      public =true
    },
    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "eu-north-1b"
    }
  }

  validation {
    condition = alltrue([
      for subnet in var.subnet_config : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", subnet.cidr_block))
    ])
    error_message = "invalid CIDR format in subnet_config"
  }
}
