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

