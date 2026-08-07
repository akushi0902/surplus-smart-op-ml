variable "name" {
  description = "Friendly name of the new secret. If omitted, Terraform will assign a random, unique name."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 512
    error_message = "Secret name must be between 1 and 512 characters."
  }
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN or ID of the AWS KMS key to be used to encrypt the secret values. If not specified, the default KMS key for the account and region is used."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery, or 7 to 30 days."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (force delete) or between 7 and 30 days."
  }
}

variable "force_overwrite_replica_secret" {
  description = "Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region."
  type        = bool
  default     = false
}

variable "replica_regions" {
  description = "List of objects defining replica regions. Each object must have a 'region' key and an optional 'kms_key_id' key."
  type = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  default = []
}

variable "secret_string" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is mutually exclusive with secret_binary."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_binary" {
  description = "Specifies binary data that you want to encrypt and store in this version of the secret. This is mutually exclusive with secret_string. Needs to be encoded to base64."
  type        = string
  default     = null
  sensitive   = true
}

variable "version_stages" {
  description = "List of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret."
  type        = list(string)
  default     = null
}

variable "enable_rotation" {
  description = "Whether to enable automatic rotation for this secret."
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "ARN of the Lambda function that can rotate the secret. Required when enable_rotation is true."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_rotation || (var.enable_rotation && var.rotation_lambda_arn != null)
    error_message = "rotation_lambda_arn must be provided when enable_rotation is true."
  }
}

variable "rotation_automatically_after_days" {
  description = "Specifies the number of days between automatic scheduled rotations of the secret. Conflicts with rotation_schedule_expression."
  type        = number
  default     = null
}

variable "rotation_duration" {
  description = "The length of the rotation window in hours, for example 3h for a three hour window."
  type        = string
  default     = null
}

variable "rotation_schedule_expression" {
  description = "A cron() or rate() expression that defines the schedule for rotating your secret. Conflicts with rotation_automatically_after_days."
  type        = string
  default     = null
}

variable "secret_policy" {
  description = "Valid JSON document representing a resource policy. If not set, no resource policy is attached."
  type        = string
  default     = null
}

variable "block_public_policy" {
  description = "Makes an optional API call to Zelkova to validate the resource policy prevents broad access to the secret."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to assign to the secret."
  type        = map(string)
  default     = {}
}
