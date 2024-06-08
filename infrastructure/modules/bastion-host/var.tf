variable "public_ec2_key_id" {
  description = "value of the public ec2 key id to ssh into bastion host"
}

variable "subnet_id" {
  description = "value of the subnet id for bastion host to reside in"
}

variable "app_name" {
  description = "value of the app name"
  
}

variable "vpc_id" {
  description = "vpc id where the infrastructure will be deployed to. Must be in the same region as the bastion host"
  type = string
}
