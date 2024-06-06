variable "S3_ACCESS_KEY_ID" {
  type = string
  description = "value of the access key ID of Identity entitled to S3 bucket"
  
}

variable "S3_SECRET_ACCESS_KEY" {
  type = string
  description = "value of the secret access key of Identity entitled to S3 bucket"
  
}

variable "S3_BUCKET_NAME" {
  
  type = string
  description = "value of the S3 bucket name to mount in host ec2 instance"
}

variable "IMAGE_URL" {
  type = string
  description = "value of the image URL to run in ECS task"
  
}