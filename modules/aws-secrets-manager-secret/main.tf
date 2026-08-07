terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_secretsmanager_secret" "this" {
  name                           = var.name
  description                    = var.description
  kms_key_id                     = var.kms_key_id
  recovery_window_in_days        = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region     = replica.value.region
      kms_key_id = lookup(replica.value, "kms_key_id", null)
    }
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.secret_string != null || var.secret_binary != null ? 1 : 0

  secret_id      = aws_secretsmanager_secret.this.id
  secret_string  = var.secret_string
  secret_binary  = var.secret_binary
  version_stages = var.version_stages
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.enable_rotation ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_automatically_after_days
    duration                 = var.rotation_duration
    schedule_expression      = var.rotation_schedule_expression
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.secret_policy != null ? 1 : 0

  secret_arn          = aws_secretsmanager_secret.this.arn
  policy              = var.secret_policy
  block_public_policy = var.block_public_policy
}
