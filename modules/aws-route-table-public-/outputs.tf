output "route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.this.id
}

output "route_table_arn" {
  description = "The ARN of the public route table."
  value       = aws_route_table.this.arn
}

output "route_table_owner_id" {
  description = "The AWS account ID that owns the public route table."
  value       = aws_route_table.this.owner_id
}

output "route_table_vpc_id" {
  description = "The VPC ID associated with the public route table."
  value       = aws_route_table.this.vpc_id
}

output "subnet_association_ids" {
  description = "Map of subnet ID to route table association ID for all subnet associations."
  value       = { for k, v in aws_route_table_association.this : k => v.id }
}

output "gateway_association_ids" {
  description = "Map of gateway ID to route table association ID for all gateway associations."
  value       = { for k, v in aws_route_table_association.gateway : k => v.id }
}
