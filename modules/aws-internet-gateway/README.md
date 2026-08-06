# terraform-aws-internet-gateway

Provisions an AWS Internet Gateway and optionally attaches it to a VPC.

## Usage

### Inline VPC attachment (most common)


module "igw" {
  source = "./modules/internet-gateway"

  name   = "my-igw"
  vpc_id = module.vpc.vpc_id

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


### Separate attachment resource


module "igw" {
  source = "./modules/internet-gateway"

  name              = "my-igw"
  vpc_id            = null
  create_attachment = true
  attachment_vpc_id = module.vpc.vpc_id

  tags = {
    Environment = "production"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name to assign to the Internet Gateway. | `string` | — | yes |
| vpc_id | VPC ID to attach the IGW to at creation. Set to `null` to use a separate attachment. | `string` | `null` | no |
| create_attachment | Create a separate `aws_internet_gateway_attachment` resource. Only used when `vpc_id` is `null`. | `bool` | `false` | no |
| attachment_vpc_id | VPC ID for the separate attachment resource. Required when `create_attachment = true` and `vpc_id = null`. | `string` | `null` | no |
| tags | Map of tags to assign to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | The ID of the Internet Gateway. |
| internet_gateway_arn | The ARN of the Internet Gateway. |
| internet_gateway_owner_id | The AWS account ID that owns the Internet Gateway. |
| vpc_id | The VPC ID associated with the Internet Gateway. |
| tags_all | All tags assigned to the Internet Gateway. |

## Notes

- When `vpc_id` is provided, the IGW is attached inline during creation (standard approach).
- When `vpc_id` is `null` and `create_attachment = true`, a separate `aws_internet_gateway_attachment` resource is created, which is useful when the VPC is managed independently and you need to avoid circular dependencies.
- Only one Internet Gateway can be attached to a VPC at a time.
