variable "vpc_id" {
  type = string
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "allowed_ports" {
  type = list(number)
  default = [
    22,    # SSH
    80,    # HTTP
    443,   # HTTPS
    8080,  # Jenkins
    8081,  # Artifactory UI
    8082,  # Artifactory API
    9000   # SonarQube
  ]
}

variable "tags" {
  type = map(string)
}
