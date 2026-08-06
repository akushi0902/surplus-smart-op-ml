variable "name" {
  description = "Base name to assign to the NAT Gateway and related resources."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "name must be between 1 and 64 characters."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs in which to create the NAT Gateways. One NAT Gateway is created per subnet."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet_id must be provided."
  }
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create. Must not exceed the number of subnet_ids provided."
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
  description = "Whether to create new Elastic IP addresses for the NAT Gateways. Set to false to provide existing EIP allocation IDs via eip_allocation_ids. Only applicable when connectivity_type is 'public'."
  type        = bool
  default     = true
}

variable "eip_allocation_ids" {
  description = "List of existing Elastic IP allocation IDs to associate with the NAT Gateways. Required when create_eip is false and connectivity_type is 'public'. Must match nat_gateway_count in length."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
