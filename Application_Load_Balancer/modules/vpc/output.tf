
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "vpc_id" {
  value = aws_vpc.STAGE.id
}