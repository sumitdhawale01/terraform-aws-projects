terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}


provider "aws" {
    region = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}

variable "ami" {
  description = "ami"
  type = string
  default = "ami-0f559c3642608c138"
}

resource "aws_instance" "example"{
    ami = var.ami
    instance_type = var.instance_type

    tags = {
    Name = "sample-instance"
  }
}  


