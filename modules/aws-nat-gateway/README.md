# NAT Gateway Module

Creates one or more AWS NAT Gateways, optionally provisioning Elastic IP addresses for public gateways.

## Usage

### Single Public NAT Gateway (default)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name       = "my-app-prod"
  subnet_ids = ["subnet-0abc123"]

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


### Multiple Public NAT Gateways (one per AZ)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-prod"
  subnet_ids         = ["subnet-0abc123", "subnet-0def456", "subnet-0ghi789"]
  nat_gateway_count  = 3

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


### Private NAT Gateway


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = "my-app-prod"
  subnet_ids        = ["subnet-0abc123"]
  connectivity_type = "private"

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


### Bring Your Own EIPs


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-prod"
  subnet_ids         = ["subnet-0abc123"]
  create_eip         = false
  eip_allocation_ids = ["eipalloc-0abc123"]

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Base name for NAT Gateway and related resources | `string` | — | yes |
| subnet_ids | List of subnet IDs for NAT Gateways | `list(string)` | — | yes |
| nat_gateway_count | Number of NAT Gateways to create | `number` | `1` | no |
| connectivity_type | `public` or `private` | `string` | `"public"` | no |
| create_eip | Whether to create new EIPs | `bool` | `true` | no |
| eip_allocation_ids | Existing EIP allocation IDs (when create_eip = false) | `list(string)` | `[]` | no |
| tags | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_gateway_public_ips | List of public IPs |
| nat_gateway_private_ips | List of private IPs |
| nat_gateway_subnet_ids | List of subnet IDs |
| nat_gateway_network_interface_ids | List of network interface IDs |
| eip_ids | List of EIP allocation IDs created by this module |
| eip_public_ips | List of EIP public IPs created by this module |

## Notes

- `nat_gateway_count` must not exceed the length of `subnet_ids`.
- EIPs are only created/used when `connectivity_type = "public"`.
- When `create_eip = false`, supply pre-allocated EIPs via `eip_allocation_ids`.
