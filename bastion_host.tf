module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.0"
  attributes          = ["ssh", "key"]
  ssh_public_key_path = var.local_ssh_path
  generate_ssh_key    = true
  name                = "ghtt-bastion-host-key"
}

module "bastion_host" {
  source = "cloudposse/ec2-bastion-server/aws"

  enabled = true

  ami         = "ami-028eb925545f314d6"
  environment = var.stage
  name        = "ghtt-bastion-host"
  namespace   = var.namespace
  stage       = var.stage

  instance_type               = "t2.micro"
  security_groups             = [module.vpc.vpc_default_security_group_id]
  subnets                     = module.dynamic_subnets.public_subnet_ids
  key_name                    = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = true
  instance_profile            = aws_iam_instance_profile.bastion_host_profile.name
  user_data = ["sudo yum install amazon-cloudwatch-agent"] # Still currently requires manually activation on first login, look for way to automate?
  security_group_rules = [
  {
    "cidr_blocks": [
      "0.0.0.0/0"
    ],
    "description": "Allow all outbound traffic",
    "from_port": 0,
    "protocol": -1,
    "to_port": 0,
    "type": "egress"
  },
  {
    "cidr_blocks": var.whitelisted_ips,
    "description": "Allow whitelist inbound to SSH",
    "from_port": 22,
    "protocol": "tcp",
    "to_port": 22,
    "type": "ingress"
  }
]
}

resource "aws_iam_instance_profile" "bastion_host_profile" {
  name = "bastion_host_profile"
  role = aws_iam_role.bastion_host_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "bastion_host_role" {
  name               = "bastion_host_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "bastion_host_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      module.s3_bucket.bucket_arn
    ]
  }
  statement { # mirror AWS-managed CloudWatchAgentServerPolicy
    effect = "Allow"
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
        "ssm:GetParameter",
    ]
    resources = [
        "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    ]
  }
}

resource "aws_iam_policy" "bastion_host_policy" {
  name        = "bastion_host_policy"
  path        = "/"
  description = "Policy to provide S3 access permissions to EC2 and enable the CloudWatch agent"
  policy      = data.aws_iam_policy_document.bastion_host_policy.json
}

resource "aws_iam_role_policy_attachment" "bastion_host_policy_attachment" {
  role       = aws_iam_role.bastion_host_role.name
  policy_arn = aws_iam_policy.bastion_host_policy.arn
}