

resource "aws_subnet" "public_subnet_1" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_pub_1
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_subnet_1"
  }

}
resource "aws_subnet" "public_subnet_2" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_pub_2
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true


  tags = {
    Name = "pub_subnet_2"
  }

}