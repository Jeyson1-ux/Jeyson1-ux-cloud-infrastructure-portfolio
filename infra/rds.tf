resource "random_password" "rds" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.database[0].id, aws_subnet.database[1].id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }

}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "app_db"
  username = "postgres"
  password = random_password.rds.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project_name}-db"
  }
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project_name}-db-secret-v2"
  recovery_window_in_days = 0 # delete immediately, no recovery window

  tags = {
    Name = "${var.project_name}-db-secret"
  }

}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = "postgresql://postgres:${random_password.rds.result}@${aws_db_instance.main.endpoint}/app_db"

}