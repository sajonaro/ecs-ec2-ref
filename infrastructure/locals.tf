locals {
  bucket_name = "hwa-tf-state"
  table_name  = "hwaTFStateLocks"

  app_cluster_name             = "hello-world-app-cluster"
  availability_zones           = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  task_famliy                  = "hello-world-app-task-family"
  task_name                    = "hello-world-app-task"
  ecs_task_execution_role_name = "hello-world-app-task-execution-role"

  application_load_balancer_name = "hello-world-app-alb"
  target_group_name              = "hello-world-app-alb-tg"

  service_name   = "hello-world-app-service"
  container_port = 8080

  instance_type = "t3.nano"

  public_ec2_key               = file("tf-key.pub")
  autoscaling_max_size         = 2
  autoscaling_min_size         = 2
  autoscaling_desired_capacity = 2

  efs_volume_name = "hello-world-app-efs"
  container_path = "/var/www/html"

  repository_url= "628654266155.dkr.ecr.us-east-1.amazonaws.com/hello-world-app:942ea954b1433d0d1b9a411a"
  region = "eu-central-1"
}