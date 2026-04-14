output "vpc_id" {
  value = aws_vpc.dev.id
}

output "dev-igw" {
  value = aws_internet_gateway.dev-igw.id
}