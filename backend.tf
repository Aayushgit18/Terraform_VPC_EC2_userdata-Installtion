terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket  = "ayush-terraform-state1245"
    key     = "infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
