variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "ssh_cidr" {
  type = string
}

variable "enable_http" {
  type = bool
}

variable "enable_https" {
  type = bool
}

variable "enable_jenkins" {
  type = bool
}
