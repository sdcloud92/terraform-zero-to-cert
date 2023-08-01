
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
  password             = data.aws_ssm_parameter.db_instance_password.value
}

#Generate random password for our db instance
resource "random_password" "db_password" {
  length           = 8
  special          = true
  override_special = "#!*"
  min_upper        = 1
}

#Store Password in SSM
resource "aws_ssm_parameter" "db_instance_password" {
  name        = "/production/prod-myssql-rds/password" #env/db_name
  description = "Master password for RDS database"
  type        = "SecureString" #encrypted
  value       = random_password.db_password.result

  tags = {
    environment = "production"
    Owner       = "Cloud-Jedi-DB-Team"
    Name        = "db_instance_password"
  }
}

#Retrive Password
data "aws_ssm_parameter" "db_instance_password" {
  name       = "/production/prod-myssql-rds/password"
  depends_on = [aws_ssm_parameter.db_instance_password]
}

