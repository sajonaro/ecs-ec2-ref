locals {
  bucket_name = "hwa-tf-state12"
  table_name  = "hwaTFStateLocks12"

  app_cluster_name             = "hello-world-app-cluster"
  service_name                 = "hello-world-app-service"
  availability_zones           = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  task_famliy                  = "hello-world-app-task-family"
  task_name                    = "hello-world-app-task"
  ecs_task_execution_role_name = "hello-world-app-task-execution-role"
  application_load_balancer_name = "hello-world-app-alb"
  target_group_name              = "hello-world-app-alb-tg"
  container_port = 8080
  host_port      = 80
  instance_type = "t3.nano"
  public_ec2_key = file("tf-key.pub")
  container_path = "/data"
  repository_url = "730335574019.dkr.ecr.eu-central-1.amazonaws.com/hello-world-app:894bf5c088377c873deea48a"
  green_repo_url = "730335574019.dkr.ecr.eu-central-1.amazonaws.com/hello-world-app:67b6609c13b097888df97e97"
  region         = "eu-central-1"

}