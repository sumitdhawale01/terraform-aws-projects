
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name="IGW-1"
  }
}

resource "aws_route_table" "pub-rt-1" {
  vpc_id =  var.vpc_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

 tags = {
   Name = "pub-rt-1"
 }
  
}


resource "aws_route_table_association" "pub-inst-1-associon" {
  subnet_id = var.public_subnet_1
  route_table_id = aws_route_table.pub-rt-1.id
}
resource "aws_route_table_association" "pub-inst-2-associon" {
  subnet_id = var.public_subnet_2
  route_table_id = aws_route_table.pub-rt-1.id
}

