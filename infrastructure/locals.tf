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

  public_ec2_key  = file("tf-key.pub")

  container_path  = "/data"

  repository_url = "730335574019.dkr.ecr.eu-central-1.amazonaws.com/hello-world-app:894bf5c088377c873deea48a"
  region         = "eu-central-1"
}