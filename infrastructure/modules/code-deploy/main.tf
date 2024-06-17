resource "aws_codedeploy_app" "application" {
  compute_platform = "ECS"
  name             = "${var.ecs_service_name}-deploy"
}

resource "aws_codedeploy_deployment_group" "blue_green_deployment_group" {
  app_name               = aws_codedeploy_app.application.name
  deployment_group_name  = "${var.ecs_service_name}-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy.arn

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }

      target_group {
        name = var.target_group_1_name
      }

      target_group {
        name = var.target_group_2_name
      }
    }
  }

}


