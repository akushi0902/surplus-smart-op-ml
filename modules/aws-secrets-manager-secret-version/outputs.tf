output "secret_id" {
  description = "The ID of the Secrets Manager secret."
  value       = local.secret_id
}

output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = var.create_secret ? aws_secretsmanager_secret.this[0].arn : var.existing_secret_id
}

output "secret_name" {
  description = "The name of the Secrets Manager secret."
  value       = var.create_secret ? aws_secretsmanager_secret.this[0].name : null
}

output "secret_version_id" {
  description = "The unique identifier of the version of the secret."
  value       = aws_secretsmanager_secret_version.this.version_id
}

output "secret_version_arn" {
  description = "The ARN of the secret version."
  value       = aws_secretsmanager_secret_version.this.arn
}

output "secret_version_stages" {
  description = "The list of staging labels attached to this version of the secret."
  value       = aws_secretsmanager_secret_version.this.version_stages
}

output "rotation_enabled" {
  description = "Whether automatic rotation is enabled for the secret."
  value       = var.enable_rotation
}

output "kms_key_id" {
  description = "The KMS key ID used to encrypt the secret."
  value       = var.create_secret ? aws_secretsmanager_secret.this[0].kms_key_id : null
}

output "replica_regions" {
  description = "The list of replica regions configured for the secret."
  value       = var.create_secret ? aws_secretsmanager_secret.this[0].replica : []
}
