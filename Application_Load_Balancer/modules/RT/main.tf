provider "aws" {
  region = "ap-south-1"
}

resource "aws_route_table" "pub-rt-01" {
  vpc_id = var.vpc_id   

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "Stage-RT"
  }
}


resource "aws_route_table_association" "public_01" {
  subnet_id = var.subnet_id_01
  route_table_id = aws_route_table.pub-rt-01.id
}
resource "aws_route_table_association" "public_02" {
  subnet_id = var.subnet_id_02
  route_table_id = aws_route_table.pub-rt-01.id
}

# resource "aws_route_table" "pub-rt-01" {
#   vpc_id = aws_vpc.vpc_id
  

#   route {
#     cidr_block = "0.0.0.0/0"
#     # gateway_id = module.vpc.igw_id 
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "Stage-RT"
#   }
# }


# resource "aws_route_table_association" "public_01" {
#   subnet_id = aws_subnet.pub_instance_01.id
#   route_table_id = aws_route_table.pub-rt-01.id
# }
# resource "aws_route_table_association" "public_02" {
#   subnet_id = aws_subnet.pub_instance_02.id
#   route_table_id = aws_route_table.pub-rt-01.id
# }