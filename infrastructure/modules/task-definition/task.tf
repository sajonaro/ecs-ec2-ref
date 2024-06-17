resource "aws_ecs_task_definition" "app_task" {
  family                  = var.ecs_service_name
  container_definitions   = templatefile("${path.module}/task-definition.json", {
    container_name         = var.ecs_service_name
    ecr_repo_url          = var.ecr_repo_url
    #container_path could be moved to variable
    container_path        = "/s3-mount"
    volume_name           = "service-storage"
    #TODO at the moment this is hardcoded, but it should be a variable
    host_port             = var.host_port
    region                = var.aws_region
    log_group_name        = aws_cloudwatch_log_group.log_group.name
  })
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
  name              = "/ecs/${var.task_name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = var.task_name
  }
}