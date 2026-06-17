resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false         # false = public facing, true = internal only
  load_balancer_type = "application" # ALB not NLB (network load balancer)
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "alb" {
  name        = "${var.project_name}-alb-tg"
  port        = 8000
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    path = "/"  # which URL to check - root
    port = 8000 # which port to check
  }

  tags = {
    Name = "${var.project_name}-alb-tg"
  }

}

resource "aws_lb_listener" "http" { #listen on http requests
  load_balancer_arn = aws_lb.main.arn
  port              = 80     #LISTEN ON PORT 80
  protocol          = "HTTP" #HTTP protocol

  default_action {
    type             = "forward"                   # forward traffic to target group
    target_group_arn = aws_lb_target_group.alb.arn #which target group
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id # which cluster to run in
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1 # how many containers to keep running
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false # no public IP for containers!
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = "${var.project_name}-container"
    container_port   = 80 # must match task definition!
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 433
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.main.certificate_arn

  default_action {
    type             = "forward"                   # forward to target group
    target_group_arn = aws_lb_target_group.alb.arn # same target group as HTTP
  }

}