resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "alb" {
  name        = "${var.project_name}-alb-tg"
  port        = 3000
  vpc_id      = aws_vpc.main.id
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path = "/"
    port = 80
  }


  tags = {
    Name = "${var.project_name}-alb-tg"
  }

}

resource "aws_lb_listener" "listener" {
  port              = 80
  load_balancer_arn = aws_lb.main.arn
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}