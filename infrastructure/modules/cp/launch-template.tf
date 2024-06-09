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
      
      sudo yum install wget -y 
      sudo wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
      sudo yum install -y mount-s3.rpm -y
      sudo mkdir /var/s3-mount
      sudo mount-s3 ${var.S3_BUCKET_NAME} /var/s3-mount --allow-delete --allow-other --uid 1000 --gid 1000
    EOF
  )

  key_name = aws_key_pair.deployer.key_name
}

