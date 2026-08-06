# Route Table (Public) Module

Creates a public AWS route table with configurable IPv4 and IPv6 routes, and associates it with one or more subnets or gateways.

## Usage


module "public_route_table" {
  source = "./modules/route-table-public"

  name   = "my-app-public-rt"
  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.public_subnet_ids

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.igw.internet_gateway_id
    }
  ]

  ipv6_routes = [
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = module.eigw.egress_only_gateway_id
    }
  ]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name tag for the route table | `string` | — | yes |
| `vpc_id` | VPC ID in which to create the route table | `string` | — | yes |
| `subnet_ids` | Subnet IDs to associate with the route table | `list(string)` | `[]` | no |
| `gateway_ids` | Gateway IDs (igw-/vgw-) to associate with the route table | `list(string)` | `[]` | no |
| `ipv4_routes` | List of IPv4 route objects (must include `cidr_block`) | `list(map(string))` | `[]` | no |
| `ipv6_routes` | List of IPv6 route objects (must include `ipv6_cidr_block`) | `list(map(string))` | `[]` | no |
| `tags` | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `route_table_id` | ID of the public route table |
| `route_table_arn` | ARN of the public route table |
| `route_table_owner_id` | AWS account ID owning the route table |
| `route_table_vpc_id` | VPC ID associated with the route table |
| `subnet_association_ids` | Map of subnet ID → association ID |
| `gateway_association_ids` | Map of gateway ID → association ID |

## Route Object Keys

Each entry in `ipv4_routes` supports the following keys:

| Key | Description |
|-----|-------------|
| `cidr_block` | **(Required)** Destination IPv4 CIDR |
| `gateway_id` | Internet or virtual private gateway ID |
| `nat_gateway_id` | NAT gateway ID |
| `transit_gateway_id` | Transit gateway ID |
| `vpc_peering_connection_id` | VPC peering connection ID |
| `network_interface_id` | ENI ID |
| `vpc_endpoint_id` | VPC endpoint ID |
| `egress_only_gateway_id` | Egress-only internet gateway ID |
| `carrier_gateway_id` | Carrier gateway ID |
| `local_gateway_id` | Local gateway ID |
| `core_network_arn` | AWS Cloud WAN core network ARN |

Each entry in `ipv6_routes` uses the same keys but with `ipv6_cidr_block` instead of `cidr_block`.
