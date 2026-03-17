#Creating the ALB and assigning it public subnet then attaching the ALB SG group
resource "aws_lb" "app_lb" {
  name = "app-lb-${terraform.workspace}"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_sg_id]
  subnets = var.public_cidr_subnet_id
  tags = {
    Name = "app-lb-${terraform.workspace}"
  }
}

#Target Group chooses the healthy server and send the traffic
resource "aws_lb_target_group" "app_lb_tg" {
  name = "app-lb-tg-${terraform.workspace}"
  port = 5000
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "app-lb-tg-${terraform.workspace}"
  }
}

#Listens and take the traffic to the target group we mentioned
resource "aws_lb_listener" "app_lb_ls" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }

}

#User request goes to the Load Balancer, the listener decides where to send it, 
#the target group chooses a healthy server, and that server responds.