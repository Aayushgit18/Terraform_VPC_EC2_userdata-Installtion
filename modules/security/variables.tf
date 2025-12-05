variable "vpc_id" {}
variable "ssh_cidr" {}
variable "tags" {}

variable "allowed_ports" {
  type        = list(number)
  description = "Ports allowed inbound"
  default     = [22, 80, 443]
}
