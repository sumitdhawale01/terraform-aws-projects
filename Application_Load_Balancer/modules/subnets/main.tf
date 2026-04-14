provider "aws" {
  region = "ap-south-1"
}

resource "aws_subnet" "pub_instance_01" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_01"
  }
}
resource "aws_subnet" "pub_instance_02" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet2_cidr_block
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub_instance_02"
  }
}

