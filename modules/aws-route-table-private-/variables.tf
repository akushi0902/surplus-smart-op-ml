variable "name" {
  description = "Name of the private route table. Used as the Name tag."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "The name must not be empty."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which to create the private route table."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the private route table."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-", id))])
    error_message = "All subnet_ids must be valid subnet IDs starting with 'subnet-'."
  }
}

variable "gateway_ids" {
  description = "List of gateway IDs (e.g. internet gateway, VPN gateway) to associate with the route table at the gateway level."
  type        = list(string)
  default     = []
}

variable "ipv4_routes" {
  description = <<-EOT
    List of IPv4 route objects to add to the route table. Each object must include
    'cidr_block' and at least one target key: nat_gateway_id, transit_gateway_id,
    vpc_peering_connection_id, vpc_endpoint_id, network_interface_id,
    egress_only_gateway_id, gateway_id, or core_network_arn.
  EOT
  type = list(object({
    cidr_block                = string
    nat_gateway_id            = optional(string)
    transit_gateway_id        = optional(string)
    vpc_peering_connection_id = optional(string)
    vpc_endpoint_id           = optional(string)
    network_interface_id      = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    core_network_arn          = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ipv4_routes : can(cidrhost(r.cidr_block, 0))
    ])
    error_message = "All ipv4_routes entries must have a valid IPv4 CIDR block."
  }
}

variable "ipv6_routes" {
  description = <<-EOT
    List of IPv6 route objects to add to the route table. Each object must include
    'ipv6_cidr_block' and at least one target key: nat_gateway_id, transit_gateway_id,
    vpc_peering_connection_id, vpc_endpoint_id, network_interface_id,
    egress_only_gateway_id, gateway_id, or core_network_arn.
  EOT
  type = list(object({
    ipv6_cidr_block           = string
    nat_gateway_id            = optional(string)
    transit_gateway_id        = optional(string)
    vpc_peering_connection_id = optional(string)
    vpc_endpoint_id           = optional(string)
    network_interface_id      = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    core_network_arn          = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to all resources in this module."
  type        = map(string)
  default     = {}
}
