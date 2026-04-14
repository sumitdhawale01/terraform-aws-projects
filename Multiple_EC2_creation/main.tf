provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "e1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_value
  count = 3
  tags = {
    Name= "Sample_instance ${count.index}"
  }
}