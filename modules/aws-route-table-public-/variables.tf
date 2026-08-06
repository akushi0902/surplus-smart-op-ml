variable "name" {
  description = "Name to assign to the public route table. Used as the Name tag."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "name must be between 1 and 255 characters."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC in which to create the route table."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID (e.g. vpc-0abc1234)."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the public route table."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for s in var.subnet_ids : can(regex("^subnet-[a-f0-9]+$", s))])
    error_message = "All subnet_ids must be valid subnet IDs (e.g. subnet-0abc1234)."
  }
}

variable "gateway_ids" {
  description = "List of internet gateway or virtual private gateway IDs to associate with the route table at the gateway level."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for g in var.gateway_ids : can(regex("^(igw|vgw)-[a-f0-9]+$", g))])
    error_message = "All gateway_ids must be valid internet gateway (igw-) or virtual private gateway (vgw-) IDs."
  }
}

variable "ipv4_routes" {
  description = <<-EOT
    List of IPv4 route objects to add to the route table. Each object must include
    `cidr_block` and at least one target key such as `gateway_id`, `nat_gateway_id`,
    `transit_gateway_id`, `vpc_peering_connection_id`, `network_interface_id`,
    `vpc_endpoint_id`, `egress_only_gateway_id`, `carrier_gateway_id`,
    `local_gateway_id`, or `core_network_arn`.
  EOT
  type        = list(map(string))
  default     = []

  validation {
    condition     = alltrue([for r in var.ipv4_routes : can(r["cidr_block"])])
    error_message = "Each entry in ipv4_routes must contain a 'cidr_block' key."
  }
}

variable "ipv6_routes" {
  description = <<-EOT
    List of IPv6 route objects to add to the route table. Each object must include
    `ipv6_cidr_block` and at least one target key such as `gateway_id`, `nat_gateway_id`,
    `transit_gateway_id`, `vpc_peering_connection_id`, `network_interface_id`,
    `vpc_endpoint_id`, `egress_only_gateway_id`, `carrier_gateway_id`,
    `local_gateway_id`, or `core_network_arn`.
  EOT
  type        = list(map(string))
  default     = []

  validation {
    condition     = alltrue([for r in var.ipv6_routes : can(r["ipv6_cidr_block"])])
    error_message = "Each entry in ipv6_routes must contain an 'ipv6_cidr_block' key."
  }
}

variable "tags" {
  description = "A map of tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
