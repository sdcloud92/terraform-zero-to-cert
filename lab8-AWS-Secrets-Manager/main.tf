# Storing Secrets in AWS Secrets Manager (Not Free)

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "prod-db" {
  identifier           = "prod-myssql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = data.aws_secretsmanager_secret_version.secret_db_instance_password.secret_string
}

#Generate random password for our db instance
resource "random_password" "db_password" {
  length           = 8
  special          = true
  override_special = "#!*"
  min_upper        = 1
}

#Store Password in Secrets Manager
resource "aws_secretsmanager_secret" "secret_db_instance_password" {
  name                    = "/production/prod-myssql-rds/password" #env/db_name"
  description             = "Password for my RDS Database"
  recovery_window_in_days = 0 #Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery
}

#Store All RDS Parameters in Secrets Manager
resource "aws_secretsmanager_secret" "prod-myssql-rds" {
  name                    = "/production/prod-myssql-rds/all" #env/db_name"
  description             = "All details for my RDS Database"
  recovery_window_in_days = 0 #Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery
}

#A resource to manage AWS Secrets Manager secret version including its secret value.
resource "aws_secretsmanager_secret_version" "secret_db_instance_password" {
  secret_id     = aws_secretsmanager_secret.secret_db_instance_password.id #location where secret is stored
  secret_string = "random_password.db_password.result"
}

#A resource to manage AWS Secrets Manager secret version including its secret value.
resource "aws_secretsmanager_secret_version" "prod-myssql-rds" {
  secret_id = aws_secretsmanager_secret.prod-myssql-rds.id #location where secret is stored
  secret_string = jsonencode({
    rds_address     = aws_db_instance.prod-db.address
    rds_port        = aws_db_instance.prod-db.port
    rds_resource_id = aws_db_instance.prod-db.id
    rds_username    = aws_db_instance.prod-db.username
    rds_password    = random_password.db_password.result #Don't do this in the office!!!
  })
}

# Retrieve Password
data "aws_secretsmanager_secret_version" "secret_db_instance_password" {
  secret_id  = aws_secretsmanager_secret.secret_db_instance_password.id
  depends_on = [aws_secretsmanager_secret_version.secret_db_instance_password]
}

#Retrive All
data "aws_secretsmanager_secret_version" "prod-myssql-rds" {
  secret_id  = aws_secretsmanager_secret.prod-myssql-rds.id
  depends_on = [aws_secretsmanager_secret_version.prod-myssql-rds]
}


