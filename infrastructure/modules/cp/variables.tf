variable "app_name" {
    type = string
  
}

variable "vpc_id" {
  type = string
  description = "value of the VPC ID"
}

variable "instance_type" {
  type = string
  description = "value of the instance type"
  default = "t3.nano"
}

variable "ecs_cluster_name" {
  type = string
  description = "value of the ECS cluster name to attach infranstructure to"
  
}

variable "min_num_of_instances" {
  type = number
  description = "minimum number of EC2 instances in autoscaling group"
  default = 1
}

variable "max_num_of_instances" {
  type = number
  description = "maximum number of EC2 instances in autoscaling group"
}

variable "subnet_ids" {
  type = list(string)
  description = "list of subnet IDs to attach autoscaling group to"
  
}


variable "S3_BUCKET_NAME" {
  
  type = string
  description = "value of the S3 bucket name to mount in host ec2 instance"
}

variable "public_ec2_key" {
  type = string
  description = "value of the public key to attach to EC2 instances"
  
}

variable "bastion_host_sg_id" {
  type = string
  description = "value of the security group ID of the bastion host to connect to EC2 instances from"
  
}

variable "alb_sg_id" {
  type = string
  description = "value of the security group ID of the ALB to connect to EC2 instances from"
  
}

variable "region" {
  type = string
  description = "value of the region"
  
}