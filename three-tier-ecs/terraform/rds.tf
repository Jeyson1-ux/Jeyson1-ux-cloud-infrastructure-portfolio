resource "random_password" "db" {
  length  = 16
  special = false

}


resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-du-subnet-group"
  }
}




resource "aws_db_instance" "rds" {
  identifier              = "${var.project_name}-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = random_password.db.result
  db_subnet_group_name    = aws_db_subnet_group.main.name
  allocated_storage       = 20
  vpc_security_group_ids  = [aws_security_group.rds.id]
  skip_final_snapshot     = true
  backup_retention_period = 0 // no automatic backups, costs money, in prod never use 0, loses data and money if db crashes
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project_name}-db-secret"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.project_name}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = "postgres://${var.db_username}:${random_password.db.result}@${aws_db_instance.rds.endpoint}/${var.db_name}"
}