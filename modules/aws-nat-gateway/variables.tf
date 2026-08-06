variable "name" {
  description = "Name prefix for the NAT Gateway and associated resources."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "The name must be between 1 and 64 characters."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs in which to create the NAT Gateway(s). One NAT Gateway will be created per subnet ID provided (up to nat_gateway_count)."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID must be provided."
  }
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create. Must not exceed the number of subnet IDs provided."
  type        = number
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 1
    error_message = "nat_gateway_count must be at least 1."
  }
}

variable "connectivity_type" {
  description = "Connectivity type for the NAT Gateway. Valid values are 'public' or 'private'."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.connectivity_type)
    error_message = "connectivity_type must be either 'public' or 'private'."
  }
}

variable "create_eip" {
  description = "Whether to create new Elastic IP addresses for the NAT Gateway(s). Set to false to provide existing EIP allocation IDs via eip_allocation_ids."
  type        = bool
  default     = true
}

variable "eip_allocation_ids" {
  description = "List of existing Elastic IP allocation IDs to associate with the NAT Gateway(s). Required when create_eip is false and connectivity_type is 'public'. Must match nat_gateway_count in length."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
