variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "azs" {
  type    = number
  default = 2
}

variable "ami" {
  type    = string
  default = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = "ansible-key"
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "nat" {
  type    = bool
  default = true
}

variable "ebs_size" {
  type    = number
  default = 8
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "my-ec2"
    Owner       = "ayush"
    Environment = "dev"
  }
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "enable_http" {
  type    = bool
  default = true
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "enable_jenkins" {
  type    = bool
  default = true
}
