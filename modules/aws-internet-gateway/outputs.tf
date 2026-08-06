output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway."
  value       = aws_internet_gateway.this.arn
}

output "internet_gateway_owner_id" {
  description = "The ID of the AWS account that owns the Internet Gateway."
  value       = aws_internet_gateway.this.owner_id
}

output "internet_gateway_vpc_id" {
  description = "The VPC ID that the Internet Gateway is attached to (if attached at creation time)."
  value       = aws_internet_gateway.this.vpc_id
}

output "attachment_id" {
  description = "The ID of the separate Internet Gateway attachment resource, if created."
  value       = length(aws_internet_gateway_attachment.this) > 0 ? aws_internet_gateway_attachment.this[0].id : null
}
