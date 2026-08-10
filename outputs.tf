output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "subnet_id" {
  value = module.subnet.subnet_id
}

output "subnet_cidr_block" {
  value = module.subnet.subnet_cidr_block
}

output "route_table_id" {
  value = module.subnet.route_table_id
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "security_group_arn" {
  value = module.security_group.security_group_arn
}

output "security_group_name" {
  value = module.security_group.security_group_name
}

output "role_arn" {
  value = module.iam_role.role_arn
}

output "role_name" {
  value = module.iam_role.role_name
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_arn" {
  value = module.ec2.instance_arn
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "availability_zone" {
  value = module.ec2.availability_zone
}
