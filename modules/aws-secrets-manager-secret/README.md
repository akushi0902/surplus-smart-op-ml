# Terraform Module: AWS Secrets Manager Secret

Creates and manages an AWS Secrets Manager secret, including optional secret version, automatic rotation, replica regions, and resource policy.

## Usage


module "secret" {
  source = "./modules/secrets-manager"

  name        = "my-app/database-credentials"
  description = "Database credentials for my application"
  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/mrk-abc123"

  secret_string = jsonencode({
    username = "admin"
    password = "supersecret"
  })

  recovery_window_in_days = 7

  enable_rotation                   = true
  rotation_lambda_arn               = "arn:aws:lambda:us-east-1:123456789012:function:my-rotation-fn"
  rotation_automatically_after_days = 30

  replica_regions = [
    {
      region     = "us-west-2"
      kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/mrk-def456"
    }
  ]

  secret_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:role/my-role" }
        Action    = "secretsmanager:GetSecretValue"
        Resource  = "*"
      }
    ]
  })

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Friendly name of the secret | `string` | — | yes |
| description | Description of the secret | `string` | `null` | no |
| kms_key_id | ARN or ID of the KMS key for encryption | `string` | `null` | no |
| recovery_window_in_days | Days before permanent deletion (0 or 7–30) | `number` | `30` | no |
| force_overwrite_replica_secret | Overwrite replica secret with same name | `bool` | `false` | no |
| replica_regions | List of replica region objects (`region`, optional `kms_key_id`) | `list(object)` | `[]` | no |
| secret_string | Plaintext secret value (sensitive) | `string` | `null` | no |
| secret_binary | Base64-encoded binary secret value (sensitive) | `string` | `null` | no |
| version_stages | Staging labels for the secret version | `list(string)` | `null` | no |
| enable_rotation | Enable automatic secret rotation | `bool` | `false` | no |
| rotation_lambda_arn | ARN of the rotation Lambda function | `string` | `null` | no |
| rotation_automatically_after_days | Days between rotations (1–1000) | `number` | `null` | no |
| rotation_duration | Rotation window duration (e.g. `3h`) | `string` | `null` | no |
| rotation_schedule_expression | Cron/rate expression for rotation schedule | `string` | `null` | no |
| secret_policy | JSON resource policy document | `string` | `null` | no |
| block_public_policy | Validate policy prevents broad access | `bool` | `true` | no |
| tags | Map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret_id | ID of the secret |
| secret_arn | ARN of the secret |
| secret_name | Name of the secret |
| secret_version_id | Unique identifier of the secret version |
| secret_version_arn | ARN of the secret version |
| rotation_enabled | Whether automatic rotation is enabled (true when an `aws_secretsmanager_secret_rotation` resource is present) |
| replica_statuses | Replication status details |
