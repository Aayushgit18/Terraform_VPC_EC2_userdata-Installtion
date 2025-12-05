output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_id" {
  value = module.security.sg_id
}

output "ec2_public_ips" {
  value = module.ec2.public_ips
}
