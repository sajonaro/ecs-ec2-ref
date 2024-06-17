terraform {
  required_version = "~> 1.3"


  /* 
 backend "s3" {
    bucket         = "hwa-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1" 
    dynamodb_table = "hwaTFStateLocks"
    encrypt        = true
  }
*/

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

/*
module "ecrRepo" {
  source = "./modules/ecr"
  ecr_repo_name = local.ecr_repo_name
}*/


module "dns-and-certificate-settings" {
  source = "./modules/dns-and-certificate"
  dns_name = var.dns_name
  forward_to_dns_name = module.ecs-cluster.alb_dns_name
  forward_to_zone_id = module.ecs-cluster.alb_zone_id
}

module "task-execution-role" {
  source = "./modules/task-execution-role"
  ecs_task_execution_role_name   = local.ecs_task_execution_role_name
}


module "blue-task-definition" {
  source = "./modules/task-definition"
  ecr_repo_url                   = local.repository_url
  task_name                      = "hw-app-blue"
  host_port                      = local.host_port
  aws_region                     = local.region
  ecs_task_execution_role_arn    = module.task-execution-role.task_execution_role_arn
  container_path                 = local.container_path
  ecs_service_name               =  local.service_name
}

## create new task definition to be used by code deploy (via task arn in appspec.yml)
module "green-task-definition" {
  source = "./modules/task-definition"
  ecr_repo_url                   = local.green_repo_url
  task_name                      = "hw-app-green"
   ecs_service_name              =  local.service_name
  host_port                      = local.host_port
  aws_region                     = local.region
  ecs_task_execution_role_arn    = module.task-execution-role.task_execution_role_arn
  container_path                 = local.container_path
}


#define cluster (service, task)
module "ecs-cluster" {
  source = "./modules/ecs"
  app_cluster_name               = local.app_cluster_name
  availability_zones             = local.availability_zones
  task_famliy                    = local.task_famliy
  container_port                 = local.container_port
  #start with "blue"(old) instance
  task_definition_arn            = module.blue-task-definition.task_definition_arn
  application_load_balancer_name = local.application_load_balancer_name
  service_name                   = local.service_name
  region                         = local.region
  desired_count                  = 1
  alb_certificate_arn            = module.dns-and-certificate-settings.certificate_arn

}

#provide infrastrcture (ec2 instances) for cluster to run on
module "capacity-provider" {
  source               = "./modules/cp"
  vpc_id               = module.ecs-cluster.vpc_id
  subnet_ids           = module.ecs-cluster.vpc_az_ids
  instance_type        = local.instance_type
  ecs_cluster_name     = local.app_cluster_name
  min_num_of_instances = 1
  max_num_of_instances = 1
  app_name             = local.service_name
  S3_BUCKET_NAME       = var.S3_BUCKET_NAME
  public_ec2_key       = local.public_ec2_key
  alb_sg_id            = module.ecs-cluster.alb_sg_id
  bastion_host_sg_id   = module.bastion-host.bastion_host_sg_id
  region               = var.region
}

#define bastion host to be able to ssh into EC2 instances defined via capacity-provider module
module "bastion-host" {
  source            = "./modules/bastion-host"
  vpc_id            = module.ecs-cluster.vpc_id
  public_ec2_key_id = module.capacity-provider.public_ec2_key_id
  subnet_id         = module.ecs-cluster.public_subnet_id
  app_name          = local.service_name
}

#define code deploy ready to implement blue/green swap
module "glue-green-code-deploy" {
  source            = "./modules/code-deploy"
  region            =  local.region
  ecs_cluster_name  =  local.app_cluster_name
  ecs_service_name  =  local.service_name
  target_group_1_name = module.ecs-cluster.target_group_1_name
  target_group_2_name = module.ecs-cluster.target_group_2_name
  listener_arn        = module.ecs-cluster.listener_arn
  app_task_role_arn   = module.task-execution-role.task_execution_role_arn
}