data template_file task_definition {
  template = file("${path.module}/container-definition.tpl")

  vars = {
    name                  = var.container_name
    ecr_repo_url          = var.ecr_repo_url
    #container_path could be moved to variable
    container_path        = "/s3-mount"
    volume_name           = "service-storage"
    region                = var.aws_region
    log_group_name        = aws_cloudwatch_log_group.log_group.name
  }
}