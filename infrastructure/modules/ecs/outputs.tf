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
  value = aws_security_group.lb_sg_443.id
}

output "application_url" {
  description = "value of the URL of the ALB to connect to EC2 instances from"
  value = aws_alb.application_load_balancer.dns_name
}

output "alb_dns_name" {
  description = "value of the DNS name of the ALB to connect to EC2 instances from"
  value = aws_alb.application_load_balancer.dns_name
  
}

output "alb_zone_id" {
  description = "value of the zone ID of the ALB to connect to EC2 instances from"
  value = aws_alb.application_load_balancer.zone_id
  
}