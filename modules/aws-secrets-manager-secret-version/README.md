# Secrets Manager Secret Version Module

This module manages an AWS Secrets Manager secret and its version, with optional support for automatic rotation, resource policies, and cross-region replication.

## Usage

### Create a new secret with a string value


module "db_password" {
  source = "./modules/secrets-manager-secret-version"

  create_secret = true
  secret_name   = "prod/myapp/db-password"
  description   = "Production database password for myapp"
  secret_string = jsonencode({
    username = "admin"
    password = "s3cr3t!"
  })

  kms_key_id              = "arn:aws:kms:us-east-1:123456789012:key/abc123"
  recovery_window_in_days = 7

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


### Create a secret with automatic rotation


module "api_key" {
  source = "./modules/secrets-manager-secret-version"

  create_secret = true
  secret_name   = "prod/myapp/api-key"
  secret_string = "initial-api-key-value"

  enable_rotation                  = true
  rotation_lambda_arn              = "arn:aws:lambda:us-east-1:123456789012:function:rotate-secret"
  rotation_automatically_after_days = 90

  tags = {
    Environment = "prod"
  }
}


### Add a version to an existing secret


module "existing_secret_version" {
  source = "./modules/secrets-manager-secret-version"

  create_secret      = false
  existing_secret_id = "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/myapp/db-password-AbCdEf"
  secret_string      = "new-secret-value"

  tags = {}
}


### Secret with cross-region replication


module "replicated_secret" {
  source = "./modules/secrets-manager-secret-version"

  create_secret = true
  secret_name   = "prod/myapp/global-config"
  secret_string = "{\"key\": \"value\"}"

  replica_regions = [
    { region = "us-west-2" },
    { region = "eu-west-1", kms_key_id = "arn:aws:kms:eu-west-1:123456789012:key/xyz789" }
  ]

  tags = {
    Environment = "prod"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create_secret` | Whether to create a new secret | `bool` | `true` | no |
| `existing_secret_id` | ID/ARN of existing secret (when create_secret=false) | `string` | `null` | conditional |
| `secret_name` | Name of the secret (when create_secret=true) | `string` | `null` | conditional |
| `description` | Description of the secret | `string` | `null` | no |
| `kms_key_id` | KMS key ARN/ID for encryption | `string` | `null` | no |
| `recovery_window_in_days` | Days before secret can be deleted (0 or 7-30) | `number` | `30` | no |
| `replica_regions` | List of replica region configurations | `list(object)` | `[]` | no |
| `secret_string` | Plaintext secret value | `string` | `null` | conditional |
| `secret_binary` | Base64-encoded binary secret value | `string` | `null` | conditional |
| `version_stages` | Staging labels for this version | `list(string)` | `[]` | no |
| `enable_rotation` | Enable automatic rotation | `bool` | `false` | no |
| `rotation_lambda_arn` | Lambda ARN for rotation | `string` | `null` | conditional |
| `rotation_automatically_after_days` | Days between rotations (1-365) | `number` | `30` | no |
| `secret_policy` | JSON resource policy for the secret | `string` | `null` | no |
| `block_public_policy` | Block public access via resource policy | `bool` | `true` | no |
| `tags` | Map of tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `secret_id` | The ID of the secret |
| `secret_arn` | The ARN of the secret |
| `secret_name` | The name of the secret |
| `secret_version_id` | The unique version identifier |
| `secret_version_arn` | The ARN of the secret version |
| `secret_version_stages` | Staging labels on this version |
| `rotation_enabled` | Whether rotation is enabled |
| `kms_key_id` | KMS key used for encryption |
| `replica_regions` | Configured replica regions |

## Notes

- By default, changes to `secret_string` and `secret_binary` are ignored after initial creation to prevent Terraform from overwriting secrets managed out-of-band (e.g., by rotation Lambda functions).
- Exactly one of `secret_string` or `secret_binary` should be provided for the secret version.
- When `recovery_window_in_days` is set to `0`, the secret is force-deleted immediately without a recovery window.
