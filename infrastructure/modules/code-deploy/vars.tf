variable "region" {
    description = "value of the region"
  
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

variable "listener_arn" {
  description = "value of the listener arn"
  
}

variable "app_task_role_arn" {
    description = "value of the task role arn"
  
}