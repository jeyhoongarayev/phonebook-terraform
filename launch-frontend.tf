//Creating backend-instance-ec2-key
resource "tls_private_key" "template_frontend_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "frontend-instance-ec2-key" {
  key_name   = "key_frontend"
  public_key = tls_private_key.template_frontend_key.public_key_openssh
}

resource "aws_launch_template" "launch-frontend" {
  name          = "frontend"
  instance_type = "t2.micro"

  image_id = "ami-0b61338ea901bed08"

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  key_name = aws_key_pair.frontend-instance-ec2-key.key_name

  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      aws_security_group.webserver-security-group.id,
      aws_security_group.ssh-security-group.id
    ]
  }

  placement {
    availability_zone = "eu-central-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "my-frontend-app"
    }
  }

  user_data = templatefile("files/frontend-deploy-data.sh", {
    backend_url = aws_lb_listener.http_backend.arn
  })
}