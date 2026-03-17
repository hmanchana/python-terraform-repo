resource "aws_subnet" "public" {
    count = length(var.public_cidr_subnet)
    vpc_id = var.vpc_id
    cidr_block = var.public_cidr_subnet[count.index]
    availability_zone = var.az[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet-${count.index + 1}-${terraform.workspace}"
      Environment = terraform.workspace
      type = "public"
    }
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr_subnet)
  vpc_id = var.vpc_id
  cidr_block = var.private_cidr_subnet[count.index]
  availability_zone = var.az[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}-${terraform.workspace}"
    Environment = terraform.workspace
    type = "private"
  }
}