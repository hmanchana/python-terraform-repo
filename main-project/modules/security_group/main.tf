resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id
  name = "bastion-sg-${terraform.workspace}"
  description = "Allow SSH from the IP"

  ingress {
    description = "All SSH from IP"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["122.177.247.153/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "alb_sg" {
  name = "alb-sg-${terraform.workspace}"
  description = "Allow Http from Internet"
  vpc_id = var.vpc_id

  ingress {
    description = "Http from Internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-${terraform.workspace}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg-${terraform.workspace}"
  description = "Allow Http from ALB"
  vpc_id = var.vpc_id

  ingress {
    description = "Http from ALB"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
   
  ingress {
    description = "SSH from Bastion Only"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow All Outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
  Name = "ec2-sg-${terraform.workspace}"
}
}