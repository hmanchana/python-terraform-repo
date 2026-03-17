resource "aws_key_pair" "main" {
  key_name   = "main-key"
  public_key = file("~/.ssh/main-key.pub")
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.cidr_block
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  private_cidr_subnet = var.public_cidr_subnet
  public_cidr_subnet = var.private_cidr_subnet
  az = var.az
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "Nat_Gateway" {
  source = "./modules/Nat_Gateway"
  igw_id = module.igw.gateway_id
  public_cidr_subnet_id = module.subnet.public_cidr_subnet_id
}

module "Route_Table" {
  source = "./modules/Route_Table"
  vpc_id = module.vpc.vpc_id
  nat_id = module.Nat_Gateway.nat_id
  gateway_id = module.igw.gateway_id
  private_cidr_subnet_id = module.subnet.private_cidr_subnet_id
  public_cidr_subnet_id = module.subnet.public_cidr_subnet_id
  destination_cidr_block = var.destination_cidr_block
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ALB" {
  source = "./modules/ALB"
  vpc_id = module.vpc.vpc_id
  alb_sg_id = module.security_group.alb_sg_id
  public_cidr_subnet_id = module.subnet.public_cidr_subnet_id
}

module "Bastion_Ec2" {
  source = "./modules/Bastion_Ec2"
  public_cidr_subnet_id = module.subnet.public_cidr_subnet_id[0]
  bastion_sg_id = module.security_group.bastion_sg_id
  key_name = aws_key_pair.main.key_name
}

module "Ec2" {
  source = "./modules/Ec2"
  ec2_sg_id = module.security_group.ec2_sg_id
  private_cidr_subnet_id = module.subnet.private_cidr_subnet_id
  alb_tg_arn = module.ALB.alb_tg_arn
  key_name = aws_key_pair.main.key_name
}
