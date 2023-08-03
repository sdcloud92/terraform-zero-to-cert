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
