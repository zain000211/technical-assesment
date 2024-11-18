data "aws_secretsmanager_secret" "rds_secret" {
  arn = var.secret_manager_arn
}

data "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

resource "aws_db_instance" "primary_rds" {
  provider = "me-central-1"

  identifier              = var.primary_rds_name
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  allocated_storage       = var.storage
  db_name                 = var.db_name
  username                = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string).username
  password                = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string).password
  multi_az                = true
  storage_type            = "gp2"
  backup_retention_period = var.backup_retention_period
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "Primary MySQL Database"
  }
}

resource "aws_db_instance" "replica_rds" {
  provider = "us-east-1"

  identifier                     = var.secondry_rds_name
  engine                         = "mysql"
  engine_version                 = "8.0"
  instance_class                 = var.instance_class
  allocated_storage              = var.storage
  db_name                        = var.db_name
  username                       = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string).username
  password                       = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string).password
  source_db_instance_identifier  = aws_db_instance.primary_rds.id
  publicly_accessible            = false
  multi_az                       = true
  storage_type                   = "gp2"
  backup_retention_period        = var.backup_retention_period
  skip_final_snapshot            = true

  tags = {
    Name = "Replica MySQL Database"
  }
}
