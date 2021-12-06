resource "aws_db_subnet_group" "database-subnet-group" {
  name = "database subnets"
  subnet_ids = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description = "Subnet for Database Instance"

  tags = {
    Name = "Database Subnets"
  }
}

data "aws_db_snapshot" "latest-db-snapshot" {
  db_snapshot_identifier = var.database-snapshot-identifier
  most_recent = true
  snapshot_type = "manual"
}

resource "aws_db_instance" "database-instance" {
  instance_class = var.database-instance-class
  skip_final_snapshot = true
  availability_zone = "eu-central-1a"
  identifier = var.database-instance-identifier
  snapshot_identifier = data.aws_db_snapshot.latest-db-snapshot.id
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
  multi_az = var.multi-az-deployment
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
  username = var.username
  password = var.password
}