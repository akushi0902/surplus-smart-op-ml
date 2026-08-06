# terraform-aws-internet-gateway

Provisions an AWS Internet Gateway and optionally attaches it to a VPC.

## Usage

### Inline VPC attachment (most common)


module "igw" {
  source = "./modules/internet-gateway"

  name   = "my-igw"
  vpc_id = "vpc-0abc123456789def0"

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
  attachment_vpc_id = "vpc-0abc123456789def0"

  tags = {
    Environment = "production"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name tag for the Internet Gateway | `string` | — | yes |
| vpc_id | VPC ID to attach at creation time | `string` | `null` | no |
| create_attachment | Create a separate attachment resource | `bool` | `false` | no |
| attachment_vpc_id | VPC ID for the separate attachment | `string` | `null` | no |
| tags | Map of tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | ID of the Internet Gateway |
| internet_gateway_arn | ARN of the Internet Gateway |
| internet_gateway_owner_id | AWS account ID that owns the IGW |
| internet_gateway_vpc_id | VPC ID the IGW is attached to |
| attachment_id | ID of the separate attachment resource (if created) |

## Notes

- Set `vpc_id` to attach the IGW to a VPC inline (standard approach).
- Set `vpc_id = null` and `create_attachment = true` with `attachment_vpc_id` to manage the attachment lifecycle independently.
- The `Name` tag is always set from the `name` variable; additional tags are merged from `tags`.
