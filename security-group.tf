resource "aws_security_group" "alb-security-group" {
  name = "ALB Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP Access"
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }

}

resource "aws_security_group" "ssh-security-group" {
  name = "SSH Access"
  description = "Enable SSH access on Port 22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH Access"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.ssh-location]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_security_group" "webserver-security-group" {
  name = "Web Server Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SHH on Port 22 via SHH SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP Access"
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.ssh-location]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }

}

resource "aws_security_group" "database-security-group" {
  name = "Database Security Group"
  description = "Enable Mysql accsess on Port 3306"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Mysql Access"
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    cidr_blocks = [var.private-subnet-4-cidr]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [var.private-subnet-4-cidr]
  }

  tags = {
    Name = "Database Security Group"
  }
}
