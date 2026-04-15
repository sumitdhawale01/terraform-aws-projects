provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "dev" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

 tags = {
   Name = "Dev"
 }

}

# resource "aws_internet_gateway" "dev-igw" {
#     vpc_id = aws_vpc.dev.id

#     tags = {
#       Name="Dev-IGW"
#     }
  
# }