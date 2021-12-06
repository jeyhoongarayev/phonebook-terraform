resource "tls_private_key" "template_backend_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "backend-instance-ec2-key" {
  key_name   = "key_backend"
  public_key = tls_private_key.template_backend_key.public_key_openssh
}

//Launch backend instance from sh file
resource "aws_launch_template" "launch-backend" {
  name = "backend"

  instance_type = "t2.micro"

  image_id = "ami-0b61338ea901bed08"

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  key_name = aws_key_pair.backend-instance-ec2-key.key_name

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.public-subnet-1.id
    security_groups             = [
      aws_security_group.webserver-security-group.id,
      aws_security_group.ssh-security-group.id
    ]
  }

  placement {
    availability_zone = "eu-central-1b"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "my-backend-app"
    }
  }

  user_data  = templatefile("files/backend-deploy-data.sh", {
    msql_url      = "jdbc:mysql://${aws_db_instance.database-instance.address}:${aws_db_instance.database-instance.port}/${aws_db_instance.database-instance.name}",
    msql_username = aws_db_instance.database-instance.username, msql_password = aws_db_instance.database-instance.password
  })
  depends_on = [aws_db_instance.database-instance]
}
