output "secret_id" {
  description = "ID of the secret."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "ARN of the secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_name" {
  description = "Name of the secret."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_version_id" {
  description = "Unique identifier of the version of the secret."
  value       = try(aws_secretsmanager_secret_version.this[0].version_id, null)
}

output "secret_version_arn" {
  description = "ARN of the secret version."
  value       = try(aws_secretsmanager_secret_version.this[0].arn, null)
}

output "rotation_enabled" {
  description = "Whether automatic rotation is enabled for this secret."
  value       = length(aws_secretsmanager_secret_rotation.this) > 0
}

output "replica_statuses" {
  description = "Status of the secret replication."
  value       = aws_secretsmanager_secret.this.replica
}
