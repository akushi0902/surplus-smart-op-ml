# Route Table (Private) Module

Creates a private AWS Route Table with optional subnet and gateway associations, and configurable IPv4/IPv6 routes.

## Usage


module "private_route_table" {
  source = "./modules/route-table-private"

  name   = "my-app-private-rt"
  vpc_id = "vpc-0abc123456789def0"

  subnet_ids = [
    "subnet-0abc123456789def0",
    "subnet-0abc123456789def1",
  ]

  ipv4_routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = "nat-0abc123456789def0"
    },
    {
      cidr_block         = "10.1.0.0/16"
      transit_gateway_id = "tgw-0abc123456789def0"
    },
  ]

  ipv6_routes = [
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = "eigw-0abc123456789def0"
    },
  ]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the private route table (used as the Name tag) | `string` | — | yes |
| `vpc_id` | ID of the VPC | `string` | — | yes |
| `subnet_ids` | Subnet IDs to associate with the route table | `list(string)` | `[]` | no |
| `gateway_ids` | Gateway IDs to associate with the route table | `list(string)` | `[]` | no |
| `ipv4_routes` | List of IPv4 route objects | `list(object)` | `[]` | no |
| `ipv6_routes` | List of IPv6 route objects | `list(object)` | `[]` | no |
| `tags` | Map of tags to apply to all resources | `map(string)` | `{}` | no |

### Route Object Keys

Each entry in `ipv4_routes` requires `cidr_block` plus one or more target keys:
`nat_gateway_id`, `transit_gateway_id`, `vpc_peering_connection_id`, `vpc_endpoint_id`,
`network_interface_id`, `egress_only_gateway_id`, `gateway_id`, `core_network_arn`.

Each entry in `ipv6_routes` requires `ipv6_cidr_block` plus one or more of the same target keys.

## Outputs

| Name | Description |
|------|-------------|
| `route_table_id` | ID of the private route table |
| `route_table_arn` | ARN of the private route table |
| `route_table_owner_id` | AWS account ID that owns the route table |
| `route_table_vpc_id` | VPC ID associated with the route table |
| `subnet_association_ids` | Map of subnet ID → association ID |
| `gateway_association_ids` | Map of gateway ID → association ID |
