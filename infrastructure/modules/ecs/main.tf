resource "aws_ecs_cluster" "app_cluster" {
  name = var.app_cluster_name
}

resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
  
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = var.service_name
  }
}

resource "aws_alb" "application_load_balancer" {
  name               = var.application_load_balancer_name
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  security_groups = ["${aws_security_group.lb_sg_443.id}"]
}

resource "aws_security_group" "lb_sg_443" {
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "service_target_group" {
  name        = var.target_group_name
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
    target_group_arn = aws_lb_target_group.service_target_group.arn
  }
}

resource "aws_ecs_service" "app_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = var.task_definition_arn
  launch_type     = "EC2"
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.service_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = false
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.lb_sg_443.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}