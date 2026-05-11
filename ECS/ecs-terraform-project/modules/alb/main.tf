resource "aws_lb" "alb" {

  name = "ecs-fargate-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_sg
  ]

  subnets = [
    var.subnet1,
    var.subnet2
  ]

  tags = {
    Name = "ecs-fargate-alb"
  }
}

resource "aws_lb_target_group" "tg" {

  name = "ecs-target-group"

  port = 8081

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }
}   

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}