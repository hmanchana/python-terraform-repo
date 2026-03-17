data "aws_ami" "flask_app" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["flask-ubuntu-ami-*"]
  }
}

resource "aws_instance" "ec2" {
    count = length(var.private_cidr_subnet_id)

    ami = data.aws_ami.flask_app.id
    instance_type = "t3.micro"
    subnet_id = var.private_cidr_subnet_id[count.index]
    vpc_security_group_ids = [var.ec2_sg_id]
    associate_public_ip_address = false
    key_name = var.key_name

  tags = {
    Name = "app-server-${count.index + 1}-${terraform.workspace}"
  }
}

resource "aws_lb_target_group_attachment" "app_attach" {
  count = length(aws_instance.ec2)

  target_group_arn = var.alb_tg_arn
  target_id = aws_instance.ec2[count.index].id
  port = 5000
}