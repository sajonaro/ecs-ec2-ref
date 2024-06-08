resource "aws_security_group" "bastion_host" {
  name        = "${var.app_name}_SecurityGroup_BastionHost"
  description = "Bastion host Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ## The IP range could be limited to the developers IP addresses 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.public_ec2_key_id
  vpc_security_group_ids      = [aws_security_group.bastion_host.id]

  tags = {
    Name     = "${var.app_name}_EC2_BastionHost"
  }
}

