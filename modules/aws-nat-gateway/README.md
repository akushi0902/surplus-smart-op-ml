# NAT Gateway Module

This module provisions one or more AWS NAT Gateways, optionally creating Elastic IP addresses for public gateways.

## Usage

### Single Public NAT Gateway (default)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name       = "my-app-nat"
  subnet_ids = ["subnet-0abc123def456789a"]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


### Highly Available (one NAT Gateway per AZ)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-nat"
  subnet_ids         = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
  nat_gateway_count  = 3

  tags = {
    Environment = "production"
  }
}


### Private NAT Gateway


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = "my-app-private-nat"
  subnet_ids        = ["subnet-0abc123def456789a"]
  connectivity_type = "private"
  create_eip        = false

  tags = {
    Environment = "production"
  }
}


### Bring Your Own EIP


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-nat"
  subnet_ids         = ["subnet-0abc123def456789a"]
  create_eip         = false
  eip_allocation_ids = ["eipalloc-0abc123def456789a"]

  tags = {
    Environment = "production"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name prefix for the NAT Gateway and associated resources | `string` | — | yes |
| subnet_ids | List of subnet IDs in which to create the NAT Gateway(s) | `list(string)` | — | yes |
| nat_gateway_count | Number of NAT Gateways to create | `number` | `1` | no |
| connectivity_type | Connectivity type: `public` or `private` | `string` | `"public"` | no |
| create_eip | Whether to create new Elastic IPs | `bool` | `true` | no |
| eip_allocation_ids | Existing EIP allocation IDs (when create_eip is false) | `list(string)` | `[]` | no |
| tags | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_gateway_id | ID of the first NAT Gateway |
| nat_gateway_public_ips | List of public IPs of the NAT Gateways |
| nat_gateway_private_ips | List of private IPs of the NAT Gateways |
| nat_gateway_subnet_ids | List of subnet IDs for the NAT Gateways |
| nat_gateway_network_interface_ids | List of network interface IDs |
| eip_ids | List of EIP allocation IDs created by this module |
| eip_public_ips | List of public IPs of EIPs created by this module |
| connectivity_type | Connectivity type of the NAT Gateways |

## Notes

- When `nat_gateway_count > 1`, the `subnet_ids` list must contain at least `nat_gateway_count` entries.
- For high availability, deploy one NAT Gateway per Availability Zone and update private route tables accordingly.
- `create_eip` is ignored when `connectivity_type` is `"private"` (private NAT Gateways do not use EIPs).
