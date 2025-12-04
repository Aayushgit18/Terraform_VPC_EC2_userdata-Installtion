resource "aws_instance" "app" {
  count=var.instance_count
  ami=var.ami
  instance_type=var.instance_type
  key_name=var.key_name

  subnet_id=var.subnet_id
  associate_public_ip_address=var.associate_public_ip

  root_block_device {
    volume_size=var.ebs_size
    volume_type="gp3"
    delete_on_termination=true
  }

  vpc_security_group_ids=[var.sg_id]

  user_data = file("${path.module}/userdata.sh")

  tags=merge(var.tags,{Name="${var.tags["Name"]}-instance-${count.index+1}"})
}
