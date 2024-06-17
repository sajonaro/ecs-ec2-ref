
resource "aws_lb_target_group" "tgs" {
  count = length(local.target_groups)

  name        = "target-group-${element(local.target_groups, count.index)}"
  port        = 443
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
  health_check {
    matcher = "200,301,302,404"
    path    = "/"
  }

}

resource "aws_alb_listener" "l_80" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
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
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs[0].arn
  }
}

resource "aws_alb_listener" "l_443" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.alb_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs[1].arn
  }
  depends_on = [aws_lb_target_group.tgs]

  lifecycle {
    ignore_changes = [default_action]
  }
}