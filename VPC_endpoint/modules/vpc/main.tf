provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "dev" {
  cidr_block = var.vpc_cidr

 tags = {
   Name = "Dev"
 }

}

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.dev.id

    tags = {
      Name="Dev-IGW"
    }
  
}