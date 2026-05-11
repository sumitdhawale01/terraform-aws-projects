output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet1" {
  value = aws_subnet.public1.id
}

output "subnet2" {
  value = aws_subnet.public2.id
}