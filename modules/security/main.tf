resource "aws_security_group" "ec2_sg" {
  name="${var.tags["Name"]}-sg"
  description="Security group for EC2"
  vpc_id=var.vpc_id

  ingress {
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks=[var.ssh_cidr]
  }
  ingress {
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=var.enable_http?["0.0.0.0/0"]:[]
  }
  ingress {
    from_port=443
    to_port=443
    protocol="tcp"
    cidr_blocks=var.enable_https?["0.0.0.0/0"]:[]
  }
  ingress {
    from_port=8080
    to_port=8080
    protocol="tcp"
    cidr_blocks=var.enable_jenkins?["0.0.0.0/0"]:[]
  }

  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }

  tags=merge(var.tags,{Name="${var.tags["Name"]}-sg"})
}
