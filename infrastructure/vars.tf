
variable "S3_BUCKET_NAME" {
  
  type = string
  description = "value of the S3 bucket name to mount in host ec2 instance"
}

variable "IMAGE_URL" {
  type = string
  description = "value of the image URL to run in ECS task"
  
}

variable "region" {
  type = string
  description = "value of the region to deploy infrastructure to"
  
}