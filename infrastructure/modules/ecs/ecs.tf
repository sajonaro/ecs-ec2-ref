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

resource aws_efs_file_system fs {
  creation_token = var.storage_name
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = var.storage_name
  }

}

resource "aws_efs_mount_target" "mount-az-1" {
  file_system_id = aws_efs_file_system.fs.id
  subnet_id      =  aws_default_subnet.default_subnet_a.id
}

resource "aws_efs_mount_target" "mount-az-2" {
  file_system_id = aws_efs_file_system.fs.id
  subnet_id      =  aws_default_subnet.default_subnet_b.id
}

resource "aws_efs_mount_target" "mount-az-3" {
  file_system_id = aws_efs_file_system.fs.id
  subnet_id      =  aws_default_subnet.default_subnet_c.id
  
}

resource "aws_ecs_task_definition" "app_task" {
  family                  = "${var.task_name}"
  container_definitions   = templatefile("${path.module}/task-definition.json", {
    task_name             = var.task_name
    ecr_repo_url          = var.ecr_repo_url
    container_path        = var.container_path
    storage_name          = var.storage_name
  })
  network_mode            = "awsvpc"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
 

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
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
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

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  #container port is set to 8080 in task definition
  port              = var.container_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_ecs_service" "app_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.task_name}"
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
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}