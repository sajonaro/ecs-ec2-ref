variable "aws_account_id" {
    description = "value of the aws account id" 
}

variable "region" {
    description = "value of the region"
  
}

variable "application_name" {
    description = "value of the application name"
  
}

variable "ecs_cluster_name" {
    description = "value of the ecs cluster name"
  
}

variable "ecs_service_name" {
    description = "value of the ecs service name"
  
}

variable "target_group_1_name" {
    description = "value of the target group 1 name  (green or blue)"
  
}

variable "target_group_2_name" {
  description = "value of the target group 2 name (green or blue)"
}