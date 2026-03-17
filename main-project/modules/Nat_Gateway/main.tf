resource "aws_eip" "nat" {
  count = length(var.public_cidr_subnet_id)
  domain = "vpc"
  tags = {
    Name = "nat-eip-${count.index + 1}-${terraform.workspace}"
  }
}
resource "aws_nat_gateway" "this" {
  count = length(var.public_cidr_subnet_id)
 
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = var.public_cidr_subnet_id[count.index]
  tags = {
    Name = "nat-gateway-${count.index + 1}-${terraform.workspace}"
  }
  depends_on = [var.igw_id]
}