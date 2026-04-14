

resource "aws_subnet" "private_subnet_1" {
  vpc_id = var.vpc_id
  cidr_block = var.private_cidr_1
  availability_zone = var.availability_zone

  tags = {
    Name = "Private_Subnet"
  }

}