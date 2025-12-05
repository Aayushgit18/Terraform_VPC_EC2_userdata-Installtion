module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  nat         = var.nat
  tags        = var.tags
}

module "security" {
  source = "./modules/security"

  vpc_id       = module.vpc.vpc_id
  ssh_cidr     = var.ssh_cidr
  tags         = var.tags

  allowed_ports = [
    22,    # SSH
    80,    # HTTP
    443,   # HTTPS
    8080,  # Jenkins
    8081,  # Artifactory UI
    8082,  # Artifactory API
    9000   # SonarQube
  ]
}

module "ec2" {
  source              = "./modules/ec2"
  instance_count      = var.instance_count
  ami                 = var.ami
  instance_type       = var.instance_type
  key_name            = var.key_name
  subnet_id           = module.vpc.public_subnet_ids[0]
  sg_id               = module.security.sg_id
  ebs_size            = var.ebs_size
  associate_public_ip = var.associate_public_ip
  tags                = var.tags
}
