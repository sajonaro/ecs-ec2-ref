output "public_subnet_id" {
  value = aws_default_subnet.default_subnet_a.id
  
}

output "vpc_id" {
  value = aws_default_vpc.default_vpc.id
  
}

output "vpc_az_ids" {
   value = tolist([aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id])
  
}

output "alb_sg_id" {
  description = "value of the security group ID of the ALB to connect to EC2 instances from"
  value = aws_security_group.load_balancer_security_group.id
}

output "application_url" {
  description = "value of the URL of the ALB to connect to EC2 instances from"
  value = aws_alb.application_load_balancer.dns_name
}

output "task_definition_arn" {
  description = "value of the task definition ARN"
  value = aws_ecs_task_definition.app_task.arn
  
}