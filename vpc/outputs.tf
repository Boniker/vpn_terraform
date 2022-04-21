# VPC
output "vpc_target" {
  value       = module.vpc_target.vpc_id
  description = "VPC Target"
}

# Cidrs
output "vpc_target_cidr_block_target" {
  value       = var.target_cidr_block
  description = "VPC Target"
}

output "vpc_target_cidr_block_client" {
  value       = var.client_cidr_block
  description = "VPC Client"
}

#Subnets
output "subnets_private" {
  value       = module.subnets.private_subnet_ids
  description = "Subnets"
}

output "subnets_public" {
  value       = module.subnets.public_subnet_ids
  description = "Subnets"
}

#VPN
output "vpn_endpoint_arn" {
  value       = module.ec2_client_vpn.vpn_endpoint_arn
  description = "Endpoint VPN Arn"
}

output "vpn_endpoint_id" {
  value       = module.ec2_client_vpn.vpn_endpoint_id
  description = "Endpoint VPN ID"
}

output "vpn_endpoint_dns_name" {
  value       = module.ec2_client_vpn.vpn_endpoint_dns_name
  description = "VPN Endpoint DNS Name"
}

# Config file .ovpn
output "client_configuration" {
  sensitive   = true
  value       = module.ec2_client_vpn.full_client_configuration
  description = "Client Configuration"
}

# Security Group
output "sg_vpn" {
  value       = module.sg.id
  description = "SG vpn"
}
