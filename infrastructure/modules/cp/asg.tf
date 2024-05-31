# --- ECS ASG ---

resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "${var.app_name}-ecs-asg"
  vpc_zone_identifier       = var.subnet_ids
  min_size                  = var.min_num_of_instances
  max_size                  = var.max_num_of_instances 
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.app_name}-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}