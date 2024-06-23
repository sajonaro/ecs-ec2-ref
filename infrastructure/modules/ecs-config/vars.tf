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

variable "container_port" {
  description = "Container Port"
  type        = number
  
}

variable "container_name" {
  description = "Container Name"
  type        = string
  
}

variable "application_load_balancer_name" {
  description = "ALB Name"
  type        = string
}


variable "service_name" {
  description = "ECS Service Name"
  type        = string
}



variable "desired_count" {
  description = "desired Number of tasks to run"
  type        = number
  
}

variable "alb_certificate_arn" {
  description = "ARN of the SSL certificate to use for the ALB"
  type        = string
  
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
  
}