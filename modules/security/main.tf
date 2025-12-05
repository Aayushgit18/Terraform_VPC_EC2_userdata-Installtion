resource "aws_security_group" "main" {
  name        = "devsecops-sg"
  description = "Security group for DevSecOps tools"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "devsecops-sg" })
}

resource "aws_security_group_rule" "allow_inbound" {
  count             = length(var.allowed_ports)
  type              = "ingress"
  from_port         = var.allowed_ports[count.index]
  to_port           = var.allowed_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}
