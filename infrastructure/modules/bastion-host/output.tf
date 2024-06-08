output "bastion_host_sg_id" {
  description = "value of the security group ID of the bastion hosst to connect to EC2 instances from"
  value = aws_security_group.bastion_host.id
}
