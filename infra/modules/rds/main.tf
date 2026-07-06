# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security Group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL Access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    # TODO: Replace this with ECS Security Group in ECS module
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name = "assessment-db-subnet"

  subnet_ids = [
    var.private_subnet_id
  ]

  tags = {
    Name = "db-subnet-group"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier = "hotel-db"

  engine         = "postgres"
  engine_version = "16"

  instance_class    = var.instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 5432

  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible      = false
  backup_retention_period  = var.backup_retention
  deletion_protection      = var.deletion_protection
  multi_az                 = false
  skip_final_snapshot      = true

  tags = {
    Name = "hotel-postgres-db"
  }
}