resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_ec2_key
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "${var.app_name}-ecs-ec2"
  #override this with your own AMI (e.g. from var.ami )
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ecs_node_sg.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config;
      sudo apt-get update -y
      sudo apt-get install awscli -y
      sudo apt install s3fs -y
      echo ${var.S3_ACCESS_KEY_ID}:${var.S3_SECRET_ACCESS_KEY} > ~/.passwd-s3fs
      chmod 600 ~/.passwd-s3fs
      mkdir /s3-mount
      s3fs ${var.S3_BUCKET_NAME} /s3-mount -o passwd_file=~/.passwd-s3fs
    EOF
  )

  key_name = aws_key_pair.deployer.key_name
}

