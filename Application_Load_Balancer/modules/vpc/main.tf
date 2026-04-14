resource "aws_vpc" "STAGE" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name="Stage"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.STAGE.id

  tags = {
    Name="IGW-STAGE"
  }
}



