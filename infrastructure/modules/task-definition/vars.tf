variable "aws_region" {
    description = "value of the aws region" 
}

variable "ecr_repo_url" {
  description = ""
}


variable "container_path" {
  description = "path to local folder inside container (mounted to EFS)"
  type = string
}

variable "container_name" {
  description = "name of the container"
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

variable "task_definition_name" {
  description = "ECS Service Name"
  type        = string
  
}
