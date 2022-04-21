##################
#   Target VPC   #
##################
module "vpc_target" {
  source  = "cloudposse/vpc/aws"
  version = "0.28.1"

  cidr_block = var.target_cidr_block
  context    = module.this.context
}

#################################
#   Target Subnets in all AZs   #
#################################
module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.39.8"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc_target.vpc_id
  igw_id               = module.vpc_target.igw_id
  cidr_block           = module.vpc_target.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context

  tags = {
    Student   = "borys.bilkevych"
    Terrafrom = "True"
  }
}

#################################
#   Create an EC2 Client VPN    #
#################################
module "ec2_client_vpn" {
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "0.10.8"

  ca_common_name     = var.ca_common_name
  root_common_name   = var.root_common_name
  server_common_name = var.server_common_name

  name = "borys_client_VPN"

  client_cidr                   = var.client_cidr_block
  organization_name             = var.organization_name
  logging_enabled               = var.logging_enabled
  logging_stream_name           = var.logging_stream_name
  retention_in_days             = var.retention_in_days
  associated_subnets            = module.subnets.private_subnet_ids
  authorization_rules           = var.authorization_rules
  associated_security_group_ids = [module.sg.id]
  export_client_certificate     = var.export_client_certificate
  vpc_id                        = module.vpc_target.vpc_id
  dns_servers                   = var.dns_servers
  split_tunnel                  = var.split_tunnel
  context                       = module.this.context

  additional_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      description            = "Internet Route"
      target_vpc_subnet_id   = element(module.subnets.private_subnet_ids, 0)
    }
  ]
}

###########################################
# Create a special Security Group for VPN #
###########################################
module "sg" {
  source  = "cloudposse/security-group/aws"
  version = "0.4.3"

  allow_all_egress = true
  vpc_id           = module.vpc_target.vpc_id

  rules = [
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = []
      description = "Allow All Traffic from anywhere"
      self        = true
    }
  ]
}