provider "aws" {
  region = "ap-south-1"
}


resource "aws_lb" "alb" {
  internal = false
  name = "app-alb"
  load_balancer_type = "application"
  subnets = [ var.subnet_id_01, var.subnet_id_02 ]
  security_groups = [ var.sg_id ]


  tags = {
    Name = "app-alb"
  }

}

resource "aws_lb_target_group" "tg" {
    name = "app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = "/"
      protocol = "HTTP"
    #   interval = 30
    #   healthy_threshold = 2
    #   unhealthy_threshold = 2
    }
  
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attach_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.app1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.app2_id
  port             = 80
}