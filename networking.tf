module "vpc" {
  source    = "cloudposse/vpc/aws"
  version   = "2.1.0"
  namespace = var.namespace
  stage     = var.stage
  name      = "ghtt-vpc"

  ipv4_primary_cidr_block = var.ipv4_cidr_block

  assign_generated_ipv6_cidr_block = false
}

module "dynamic_subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  version            = "2.4.1"
  namespace          = var.namespace
  stage              = var.stage
  name               = "ghtt-subnets"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
  ipv4_cidr_block    = [var.ipv4_cidr_block]
}

# module "vpc_endpoints" {
#   source  = "cloudposse/vpc/aws//modules/vpc-endpoints"
#   version = "0.25.0"

#   vpc_id = module.vpc.vpc_id

#   gateway_vpc_endpoints = {
#     "s3" = {
#       name = "s3"
#       policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#           {
#             Action = [
#               "s3:*",
#             ]
#             Effect    = "Allow"
#             Principal = "*"
#             Resource  = "${module.s3_bucket.bucket_arn}"
#           },
#         ]
#       })
#     }
#   }
#   interface_vpc_endpoints = {
#     "ec2" = {
#       name                = "ec2"
#       security_group_ids  = [//bastionHostSGid//]
#       subnet_ids          = module.dynamic_subnets.private_subnet_ids
#       policy              = null
#       private_dns_enabled = false
#     }
#   }
# }