output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "private_subnet_ids" { value = module.vpc.private_subnet_ids }
output "instance_ids" { value = module.ec2.instance_ids }
output "instance_public_ips" { value = module.ec2.instance_public_ips }
output "security_group_id" { value = module.security.sg_id }
