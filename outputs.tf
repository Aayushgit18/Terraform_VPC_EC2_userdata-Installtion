output "security_group_id" {
  value = module.security.sg_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
