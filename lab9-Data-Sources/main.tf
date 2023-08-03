#Fetch data from other resources you didn't provision

provider "aws" {}

data "aws_region" "current" {}
data "aws_caller_identity" "aws_current_user" {}
data "aws_availability_zones" "available" {}
data "aws_vpc" "vpcs" {} #Return all VPC's

#Return a specific VPC
data "aws_vpc" "DeathStar" {
  tags = {
    Name = "DeathStar"
  }
}

# Create aws_subnets using data resources
resource "aws_subnet" "subnet1" {
    vpc_id = data.aws_vpc.DeathStar.id
    cidr_block = 10.0.1.0/24
    availability_zone = data.aws_availability_zones.available.names[0]
    tags {
        Name = "subnet1"
        Info = "AZ: ${data.aws_availability_zones.available.names[0]} in Region: ${data.aws_region.current.description}"
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id = data.aws_vpc.DeathStar.id
    cidr_block = 10.0.2.0/24
    availability_zone = data.aws_availability_zones.available.names[1]
    tags {
        Name = "subnet2"
        Info = "AZ: ${data.aws_availability_zones.available.names[1]} in Region: ${data.aws_region.current.description}"
    }
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}

output "region_endpoint" {
  value = data.aws_region.current.endpoint
}

output "aws_account_id" {
  value = data.aws_caller_identity.aws_current_user.account_id
}

output "aws_user_id" {
  value = data.aws_caller_identity.aws_current_user.user_id
}

output "aws_account_arn" {
  value = data.aws_caller_identity.aws_current_user.arn
}

output "availability_zones_id" {
  value = data.aws_availability_zones.available.id
}

output "availability_zones_name" {
  value = data.aws_availability_zones.available.names
}

output "aws_default_vpc_cidr" {
  value = data.aws_vpc.DeathStar.cidr_block
}

output "aws_vpc_all_ids" {
  value = data.aws_vpc.vpcs.id
}
