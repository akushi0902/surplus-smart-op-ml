terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_secretsmanager_secret" "this" {
  count = var.create_secret ? 1 : 0

  name                    = var.secret_name
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region     = replica.value.region
      kms_key_id = lookup(replica.value, "kms_key_id", null)
    }
  }

  tags = var.tags
}

locals {
  secret_id = var.create_secret ? aws_secretsmanager_secret.this[0].id : var.existing_secret_id
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id      = local.secret_id
  secret_string  = var.secret_string != null ? var.secret_string : null
  secret_binary  = var.secret_binary != null ? var.secret_binary : null
  version_stages = length(var.version_stages) > 0 ? var.version_stages : null

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
    ]
  }
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.enable_rotation ? 1 : 0

  secret_id           = local.secret_id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_automatically_after_days
  }

  depends_on = [aws_secretsmanager_secret_version.this]
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.secret_policy != null ? 1 : 0

  secret_arn          = local.secret_id
  policy              = var.secret_policy
  block_public_policy = var.block_public_policy
}
