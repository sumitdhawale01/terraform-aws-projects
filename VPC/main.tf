terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

}

#provider 
provider "aws" {
  region = "ap-south-1"
}

#create vpc
resource "aws_vpc" "dev" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "dev"
  }
}

#create subnet (public 01)
resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.dev.id
  cidr_block = var.sub1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name="public_subnet_01"
  }

}

#create subnet (public 02)
resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.dev.id
  cidr_block = var.sub2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true
    tags = {
    Name="public_subnet_02"
  }

}

#create subnet (private 01)
resource "aws_subnet" "priv_sub1" {
  vpc_id =aws_vpc.dev.id
  cidr_block =var.private_sub_01_cidr
  availability_zone = var.az_1

  tags = {
    Name = "private_subnet_01"
  }
}

#create subnet (private 02)
resource "aws_subnet" "priv_sub2" {
  vpc_id =aws_vpc.dev.id
  cidr_block =var.private_sub_02_cidr
  availability_zone = var.az_2

  tags = {
    Name = "private_subnet_02"
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "dev_igw"
  }
}

#create route table for subnets
resource "aws_route_table" "sub1_rt" {
  vpc_id = aws_vpc.dev.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name= "route_table"
  }
}

#association with subnets
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.sub1_rt.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.sub1_rt.id
}

#create first Elastic Ip needed for further NAT gateway
resource "aws_eip" "nat_eip1" {
  domain = "vpc"

  tags = {
    Name = "nat_eip1"
  }
}

#create NAT gateway
resource "aws_nat_gateway" "pvt_01_NAT" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id = aws_subnet.sub1.id

  tags = {
    Name = "nat-gtw"
  }

  depends_on = [ aws_internet_gateway.igw ]
}


#create route table for private subnet 01
resource "aws_route_table" "private_rt_01" {
  vpc_id = aws_vpc.dev.id

  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pvt_01_NAT.id
  }

  tags = {
    Name= "private_rt_01"
  }
}

#create association for route table to private subnet 01
resource "aws_route_table_association" "rtp1" {
  subnet_id = aws_subnet.priv_sub1.id
  route_table_id = aws_route_table.private_rt_01.id
}

#############
#create route table for private subnet 02
resource "aws_route_table" "private_rt_02" {
  vpc_id = aws_vpc.dev.id

  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pvt_01_NAT.id
  }

  tags = {
    Name= "private_rt_02"
  }
}

#create association for route table to private subnet 01
resource "aws_route_table_association" "rtp2" {
  subnet_id = aws_subnet.priv_sub2.id
  route_table_id = aws_route_table.private_rt_02.id
}



