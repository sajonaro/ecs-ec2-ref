variable "task_name" {
    description = "value of the task name"
} 

variable "aws_region" {
    description = "value of the aws region" 
}

variable "ecr_repo_url" {
  description = ""
}

variable "host_port" {
  description = ""
}


variable "container_path" {
  description = "path to local folder inside container (mounted to EFS)"
  type = string
}

variable "retention_in_days" {
  description = "CloudWatch Log Retention In Days"
  type        = number
  default     = 7
}

variable "ecs_task_execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  type        = string
  
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
  
}
