resource "aws_lb_target_group" "service_target_group_green" {
  name        = "tg-green-${var.service_name}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default_vpc.id
  target_type = "ip"

  #TODO
  #define health check section
  
  depends_on = [aws_alb.application_load_balancer]
}


resource "aws_lb_target_group" "service_target_group_blue" {
  name        = "tg-blue-${var.service_name}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default_vpc.id
  target_type = "ip"

  #TODO
  #define health check section
  
  depends_on = [aws_alb.application_load_balancer]
}

resource "aws_lb_listener" "listener_443" {
  load_balancer_arn  = aws_alb.application_load_balancer.arn
  certificate_arn    = var.alb_certificate_arn
  port               = "443"
  protocol           = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_target_group_blue.arn
  }
}


