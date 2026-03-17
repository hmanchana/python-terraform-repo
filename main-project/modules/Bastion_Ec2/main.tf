resource "aws_instance" "bastion_ec2" {
  ami = "ami-02774d409be696d81"
  instance_type = "t3.micro"
  vpc_security_group_ids = [var.bastion_sg_id]
  subnet_id = var.public_cidr_subnet_id
  key_name = var.key_name
  associate_public_ip_address = true

  tags = {
     Name = "bastion-ec2-${terraform.workspace}"
  }
}