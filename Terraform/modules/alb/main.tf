resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_deletion_protection = true

  access_logs {    
    bucket = "alb-logs"    
    prefix = "ELB-logs"  
  }
}

resource "aws_lb_target_group" "app_react_tg" {
  name        = var.app_react_tg
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

}

resource "aws_lb_target_group" "app_svelte_tg" {
  name        = var.app_svelte_tg
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

}


resource "aws_lb_listener" "http_listener_react" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_react_tg.arn
  }
}

resource "aws_lb_listener" "http_listener_svelte" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_svelte_tg.arn
  }
}

resource "aws_lb_listener_rule" "react_rule" {
  listener_arn = aws_lb_listener.http_listener_react.arn
  priority     = 10

  condition {
    host_header {
      values = ["react.kc.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_react_tg.arn
  }
}


resource "aws_lb_listener_rule" "svelte_rule" {
  listener_arn = aws_lb_listener.http_listener_svelte.arn
  priority     = 20

  condition {
    host_header {
      values = ["svelte.kc.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_svelte_tg.arn
  }
}
