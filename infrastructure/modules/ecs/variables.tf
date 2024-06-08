variable "app_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "availability_zones" {
  description = "us-east-1 AZs"
  type        = list(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "storage_name" {
  type = string
  default = "service_storage"
}

variable "task_famliy" {
  description = "ECS Task Family"
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch Log Retention In Days"
  type        = number
  default     = 7
}

variable "ecr_repo_url" {
  description = "ECR Repo URL"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = number
}

variable "host_port" {
  description = "Host Port"
  type        = number
  
}

variable "container_memory" {
  description = "Container Memory"
  type        = number
  default     = 128
  
}

variable "container_cpu" {
  description = "Container CPU"
  type        = number
  default     = 1
  
}

variable "task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS Task Execution Role Name"
  type        = string
}

variable "application_load_balancer_name" {
  description = "ALB Name"
  type        = string
}

variable "target_group_name" {
  description = "ALB Target Group Name"
  type        = string
}

variable "service_name" {
  description = "ECS Service Name"
  type        = string
}

variable "container_path" {
  description = "path to local folder inside container (mounted to EFS)"
  type = string
}

variable "desired_count" {
  description = "desired Number of tasks to run"
  type        = number
  
}