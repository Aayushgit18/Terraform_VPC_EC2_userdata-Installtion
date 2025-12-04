module "vpc" {
  source="./modules/vpc"
  vpc_cidr=var.vpc_cidr
  azs=var.azs
  nat=var.nat
  tags=var.tags
}
module "security" {
  source="./modules/security"
  vpc_id=module.vpc.vpc_id
  tags=var.tags
  ssh_cidr=var.ssh_cidr
  enable_http=var.enable_http
  enable_https=var.enable_https
  enable_jenkins=var.enable_jenkins
}
module "ec2" {
  source="./modules/ec2"
  instance_count=var.instance_count
  ami=var.ami
  instance_type=var.instance_type
  key_name=var.key_name
  subnet_id=module.vpc.public_subnet_ids[0]
  sg_id=module.security.sg_id
  ebs_size=var.ebs_size
  associate_public_ip=var.associate_public_ip
  tags=var.tags
}
