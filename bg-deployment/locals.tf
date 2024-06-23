locals {
  bucket_name                    = "hwa-tf-state12"
  table_name                     = "hwaTFStateLocks12"
  app_name                       = "hw-app" 
  app_cluster_name               = "hello-world-app-cluster"
  service_name                   = "hello-world-app-service"
  application_load_balancer_name = "hello-world-app-alb"
  target_group_name              = "hello-world-app-alb-tg"
  region                      = "eu-central-1"
  target_group_1_name         =  "tg-green"
  target_group_2_name         =  "tg-blue" 
  listener_arn                =  "arn:aws:elasticloadbalancing:eu-central-1:730335574019:loadbalancer/app/hello-world-app-alb/ba293ebd2bb89175"
  app_task_role_arn           =  "arn:aws:iam::730335574019:role/hello-world-app-task-execution-role"

}