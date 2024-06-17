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

output "alb_dns_name" {
  description = "value of the DNS name of the ALB used in ecs service"
  value = aws_alb.application_load_balancer.dns_name
}

output "alb_zone_id" {
  description = "value of the zone ID of the ALB used in ecs service"
  value = aws_alb.application_load_balancer.zone_id
}


output "task_definition_arn" {
  description = "value of the task definition ARN"
  value = aws_ecs_task_definition.app_task.arn
  
}

output "target_group_1_name" {
  description = "value of the target group name"
  value = aws_lb_target_group.tgs[0].name
  
}

output "target_group_2_name" {
  description = "value of the target group name"
  value = aws_lb_target_group.tgs[1].name
  
}

output "listener_arn" {
  description = "value of the listener arn"
  value = aws_alb_listener.l_443.arn
}

output "task_role_arn" {
  description = "value of the task role arn"
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_service_id" {
  value = aws_ecs_service.app_service.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.app_cluster.id
}