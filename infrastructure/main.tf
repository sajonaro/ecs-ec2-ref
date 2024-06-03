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

#define cluster (service, task)
module "ecsCluster" {
  source = "./modules/ecs"

  app_cluster_name   = local.app_cluster_name
  availability_zones = local.availability_zones

  task_famliy                    = local.task_famliy
  ecr_repo_url                   = local.repository_url
  container_port                 = local.container_port
  host_port                      = local.container_port
  task_name                      = local.task_name
  ecs_task_execution_role_name   = local.ecs_task_execution_role_name
  application_load_balancer_name = local.application_load_balancer_name
  target_group_name              = local.target_group_name
  service_name                   = local.service_name
  storage_name                   = local.efs_volume_name
  container_path                 = local.container_path
  region                         = local.region

}

#provide infrastrcture (ec2 instances) for cluster to run on
module "capacity-privider" {
  source               = "./modules/cp"
  vpc_id               = module.ecsCluster.vpc_id
  subnet_ids           = module.ecsCluster.vpc_az_ids
  instance_type        = local.instance_type
  ecs_cluster_name     = local.app_cluster_name
  min_num_of_instances = 1
  max_num_of_instances = 2
}