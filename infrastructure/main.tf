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

#define cluster service
module "ecs-config" {
  source = "./modules/ecs"

  app_cluster_name   = local.app_cluster_name
  availability_zones = local.availability_zones
  task_famliy                    = local.task_famliy
  container_port                 = local.container_port
  host_port                      = local.container_port
  container_name                 = local.service_name 
  ecs_task_execution_role_name   = local.ecs_task_execution_role_name
  application_load_balancer_name = local.application_load_balancer_name
  target_group_name              = local.target_group_name
  service_name                   = local.service_name
  container_path                 = local.container_path
  region                         = local.region
  desired_count                  = 1
  alb_certificate_arn            = module.dns-and-certificate-settings.certificate_arn
  task_definition_arn            = module.task-def.task_definition_arn
}

module "task-execution-role" {
  source = "./modules/task-execution-role"
  ecs_task_execution_role_name   = local.ecs_task_execution_role_name
}


module "task-def" {
  source = "./modules/task-definition"
  
  ecr_repo_url                   = var.IMAGE_URL
  task_definition_name           = local.task_famliy
  aws_region                     = local.region
  ecs_task_execution_role_arn    = module.task-execution-role.task_execution_role_arn
  container_path                 = local.container_path
  container_name                 = local.service_name 
}


#provide infrastrcture (ec2 instances) for cluster to run on
module "capacity-provider" {
  source               = "./modules/cp"
  vpc_id               = module.ecs-config.vpc_id
  subnet_ids           = module.ecs-config.vpc_az_ids
  instance_type        = local.instance_type
  ecs_cluster_name     = local.app_cluster_name
  min_num_of_instances = 1
  max_num_of_instances = 1
  app_name             = local.service_name
  S3_BUCKET_NAME       = var.S3_BUCKET_NAME
  public_ec2_key       = local.public_ec2_key
  alb_sg_id            = module.ecs-config.alb_sg_id
  bastion_host_sg_id   = module.bastion-host.bastion_host_sg_id
  region               = var.region
}

#define bastion host to be able to ssh into EC2 instances defined via capacity-provider module
module "bastion-host" {
  source            = "./modules/bastion-host"
  vpc_id            = module.ecs-config.vpc_id
  public_ec2_key_id = module.capacity-provider.public_ec2_key_id
  subnet_id         = module.ecs-config.public_subnet_id
  app_name          = local.service_name
}

#define dns and certificate
module "dns-and-certificate-settings" {
  source              = "./modules/dns-and-certificate"
  dns_name            = var.dns_name
  forward_to_dns_name = module.ecs-config.alb_dns_name
  forward_to_zone_id  = module.ecs-config.alb_zone_id
}