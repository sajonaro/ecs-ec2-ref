
resource "aws_lb_target_group" "tg" {
  count = length(local.target_groups)

  name        = "target-group-${element(local.target_groups, count.index)}"
  port        = 443
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_default_vpc.default_vpc.id
  health_check {
    matcher = "200,301,302,404"
    path    = "/"
  }

}

resource "aws_alb_listener" "l_80" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "l_8080" {
  load_balancer_arn = aws_lb.app_lb.id
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[1].arn
  }
}

resource "aws_alb_listener" "l_443" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = XXXX
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
  depends_on = [aws_lb_target_group.tg]

  lifecycle {
    ignore_changes = [default_action]
  }
}