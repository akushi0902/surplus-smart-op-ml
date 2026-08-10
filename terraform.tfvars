region = "ap-south-1"

vpc_name             = "ec2-instance"
vpc_cidr_block       = "10.0.0.0/16"
availability_zones   = ["ap-south-1a"]
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = []
map_public_ip_on_launch = true
enable_dns_support   = true
enable_dns_hostnames = true
enable_nat_gateway   = false
single_nat_gateway   = false

subnet_name                     = "public-ec2-instance"
subnet_cidr_block               = "10.0.1.0/24"
subnet_map_public_ip_on_launch  = true
assign_ipv6_address_on_creation = false
ipv6_cidr_block                 = null
create_route_table              = true
default_route_target_type       = "gateway_id"
default_route_target_id         = null
additional_routes               = []

security_group_name        = "ec2-instance"
security_group_description = "Security group for ec2-instance"
ingress_rules = [
  {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
revoke_rules_on_delete   = false
default_egress_allow_all = true

iam_role_name = "iam-profile-ec2-instance"
assume_role_principals = [
  {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
]
managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
iam_role_description  = ""
iam_role_path         = "/"
max_session_duration  = 3600
force_detach_policies = false
inline_policies       = {}
permissions_boundary  = null

ec2_name                             = "ec2-instance"
ami_id                               = "ami-0c02fb55956c7d316"
instance_type                        = "t3.micro"
key_name                             = "ec2-instance"
associate_public_ip                  = true
ebs_delete_on_termination            = true
ebs_encrypted                        = true
ebs_volume_type                      = "gp3"
ebs_volume_size                      = 20
monitoring                           = false
metadata_http_tokens                 = "required"
metadata_http_put_response_hop_limit = 1
user_data                            = null
user_data_base64                     = null

default_tags = {
  team = "dev"
  service = "ec2-instance"
  environment = "dev"
}
