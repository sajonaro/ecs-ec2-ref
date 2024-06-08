output "public_ec2_key_id" {
  description = "value of the public ec2 key id to ssh into bastion host"  
  value = aws_key_pair.deployer.id
}