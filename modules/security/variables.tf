variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

# List of allowed inbound ports
variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080, 8081, 8082, 9000]
}
