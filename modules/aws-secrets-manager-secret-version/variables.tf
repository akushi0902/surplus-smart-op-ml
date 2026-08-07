variable "create_secret" {
  description = "Whether to create a new Secrets Manager secret. If false, an existing secret ID must be provided via existing_secret_id."
  type        = bool
  default     = true
}

variable "existing_secret_id" {
  description = "The ID or ARN of an existing Secrets Manager secret to create a version for. Required when create_secret is false."
  type        = string
  default     = null

  validation {
    condition     = var.create_secret == true || (var.create_secret == false && var.existing_secret_id != null)
    error_message = "existing_secret_id must be provided when create_secret is false."
  }
}

variable "secret_name" {
  description = "The name of the Secrets Manager secret. Required when create_secret is true."
  type        = string
  default     = null

  validation {
    condition     = var.create_secret == false || (var.create_secret == true && var.secret_name != null)
    error_message = "secret_name must be provided when create_secret is true."
  }
}

variable "description" {
  description = "A description of the Secrets Manager secret."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN or ID of the KMS key to use for secret encryption. If not provided, the default AWS managed key is used."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "The number of days that AWS Secrets Manager waits before it can delete the secret. Must be 0 or between 7 and 30."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (force delete) or between 7 and 30."
  }
}

variable "replica_regions" {
  description = "A list of objects describing replica regions for the secret. Each object must have a 'region' key and an optional 'kms_key_id' key."
  type = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  default = []
}

variable "secret_string" {
  description = "The plaintext secret value to store. Exactly one of secret_string or secret_binary must be provided."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_binary" {
  description = "The base64-encoded binary secret value to store. Exactly one of secret_string or secret_binary must be provided."
  type        = string
  default     = null
  sensitive   = true
}

variable "version_stages" {
  description = "A list of staging labels to attach to this version of the secret. If not provided, AWS defaults to AWSCURRENT."
  type        = list(string)
  default     = []
}

variable "ignore_secret_changes" {
  description = "Whether to ignore changes to the secret value after initial creation. Defaults to true to prevent Terraform from overwriting out-of-band secret rotations."
  type        = bool
  default     = true
}

variable "enable_rotation" {
  description = "Whether to enable automatic secret rotation via a Lambda function."
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "The ARN of the Lambda function to use for secret rotation. Required when enable_rotation is true."
  type        = string
  default     = null

  validation {
    condition     = var.enable_rotation == false || (var.enable_rotation == true && var.rotation_lambda_arn != null)
    error_message = "rotation_lambda_arn must be provided when enable_rotation is true."
  }
}

variable "rotation_automatically_after_days" {
  description = "The number of days between automatic scheduled rotations of the secret."
  type        = number
  default     = 30

  validation {
    condition     = var.rotation_automatically_after_days >= 1 && var.rotation_automatically_after_days <= 365
    error_message = "rotation_automatically_after_days must be between 1 and 365."
  }
}

variable "secret_policy" {
  description = "A valid JSON policy document to attach to the secret. If null, no resource policy is created."
  type        = string
  default     = null
}

variable "block_public_policy" {
  description = "Whether to block public access to the secret via its resource policy."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to all taggable resources."
  type        = map(string)
  default     = {}
}
