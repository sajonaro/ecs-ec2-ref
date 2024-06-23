resource "aws_ecs_task_definition" "app_task" {
  family                  = var.task_definition_name
  container_definitions   = data.template_file.task_definition.rendered  

  volume {
    name = "service-storage"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "local"

      driver_opts = {
        "o"      = "bind"
        "type"   = "none"
        "device" = "/var/s3-mount"
      }
    }
  }
      
  network_mode            = "awsvpc"
  execution_role_arn      = var.ecs_task_execution_role_arn

}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.task_definition_name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = var.task_definition_name
  }
}