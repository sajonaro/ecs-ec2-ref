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


#define code deploy ready to implement blue/green swap
module "glue-green-code-deploy" {
  source              = "./modules/code-deploy"
  region              =  local.region
  ecs_cluster_name    =  local.app_cluster_name
  ecs_service_name    =  local.service_name
  target_group_1_name =  "tg-green-hello-world-app-service" 
  target_group_2_name =  "tg-blue-hello-world-app-service"
  listener_arn        =  "arn:aws:elasticloadbalancing:eu-central-1:730335574019:listener/app/hello-world-app-alb/ec1c45526365dcce/85395f3418034e54"
}