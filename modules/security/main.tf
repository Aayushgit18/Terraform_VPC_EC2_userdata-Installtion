resource "aws_security_group" "ec2_sg" {
  name        = var.tags["Name"]
  description = "Security group for EC2"
  vpc_id      = var.vpc_id

  # Ingress ports
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow inbound traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow all egress
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = var.tags
}
