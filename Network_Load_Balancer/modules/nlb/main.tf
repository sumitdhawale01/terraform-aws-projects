

resource "aws_lb" "nlb" {
  # name = "network_lb"
  internal = false
  load_balancer_type = "network"
  subnets = [ var.public_subnet_1, var.public_subnet_2 ]
  # security_groups = [ var.nlb_sg ]

  tags = {
    Name = "Network_lb"
  }
  
}

resource "aws_lb_target_group" "nlb-tg" {
  name = "nlb-tg"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "tg-attach-1" {
  target_id = var.ec1-1-id
  target_group_arn = aws_lb_target_group.nlb-tg.arn
}
resource "aws_lb_target_group_attachment" "tg-attach-2" {
  target_id = var.ec1-2-id
  target_group_arn = aws_lb_target_group.nlb-tg.arn

}

resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 80
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}


##################################

resource "aws_lb_target_group" "nlb-tg-1" {
  name = "nlb-tg-1"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "tg-attach-3" {
  target_id = var.ec1-1-id
  target_group_arn = aws_lb_target_group.nlb-tg-1.arn
}


resource "aws_lb_listener" "lb-listner-1" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 81
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg-1.arn
  }
}

#######################################################

resource "aws_lb_target_group" "nlb-tg-2" {
  name = "nlb-tg-2"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "tg-attach-4" {
  target_id = var.ec1-2-id
  target_group_arn = aws_lb_target_group.nlb-tg-2.arn

}

resource "aws_lb_listener" "lb-listner-2" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 82
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg-2.arn
  }
}


