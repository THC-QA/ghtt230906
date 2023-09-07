module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.0"
  attributes          = ["ssh", "key"]
  ssh_public_key_path = var.ssh_key_path
  generate_ssh_key    = var.generate_ssh_key
}

module "bastion_host" {
  source = "../../"

  enabled = true

  ami = "ami-028eb925545f314d6"
  environment = var.stage
  name = "ghtt-bastion-host"
  namespace = var.namespace
  stage = var.stage

  instance_type               = "t2.micro"
  security_groups             = [module.vpc.vpc_default_security_group_id]
  subnets                     = module.dynamic_subnets.public_subnet_ids
  key_name                    = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = true

  context = module.this.context
}

resource "aws_security_group_rule" "whitelist_ips" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.whitelisted_ips
  security_group_id = module.bastion_host.security_group_id
}