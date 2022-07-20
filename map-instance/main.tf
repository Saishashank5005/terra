terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0eb5f3f64b10d3e0e"
  instance_type = "t2.micro"
  count = var.instance_count
  tags = {
    Name = "terra-${count.index + 1}"
  }
}
variable "instance_count" {
  default = "2"
}
