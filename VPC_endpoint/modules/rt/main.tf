
#here we dont need to add anything into route table 
resource "aws_route_table" "route_table" {
  
  vpc_id = var.vpc_id
  route = []

  tags = {
    Name = "Route_table"
  }

}

#in this usecase we need to  do only association of subnets  to route table
resource "aws_route_table_association" "rt-association" {
  subnet_id = var.private_subnet_1
  route_table_id = aws_route_table.route_table.id
}