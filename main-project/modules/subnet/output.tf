output "public_cidr_subnet_id" {
  value = aws_subnet.public[*].id
}
output "private_cidr_subnet_id" {
  value = aws_subnet.private[*].id
}