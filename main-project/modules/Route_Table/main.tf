resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  tags = {
    Name = "rt-${terraform.workspace}"
  }
}
resource "aws_route" "public_access" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id = var.gateway_id
}
resource "aws_route_table_association" "public_subnet_rt" {
  count = length(var.public_cidr_subnet_id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = var.public_cidr_subnet_id[count.index]
}

resource "aws_route_table" "private_route_table" {
  count = length(var.private_cidr_subnet_id)
  vpc_id = var.vpc_id
  tags = {
    Name = "rt-${count.index + 1}-${terraform.workspace}"
  }
}
resource "aws_route" "private_access" {
  count = length(var.private_cidr_subnet_id)
  route_table_id = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id  = var.nat_id[count.index]
}
resource "aws_route_table_association" "private_subnet_rt" {
  count = length((var.private_cidr_subnet_id))
  route_table_id = aws_route_table.private_route_table[count.index].id
  subnet_id = var.private_cidr_subnet_id[count.index]
}