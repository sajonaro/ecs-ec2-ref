# --- ECS Node SG ---

resource "aws_security_group" "ecs_node_sg" {
  name_prefix = "${var.app_name}-ecs-node-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}