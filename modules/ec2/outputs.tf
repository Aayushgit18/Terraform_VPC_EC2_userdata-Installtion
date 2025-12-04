output "instance_ids" { value=[for i in aws_instance.app: i.id] }
output "instance_public_ips" { value=[for i in aws_instance.app: i.public_ip] }
