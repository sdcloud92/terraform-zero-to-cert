

output "rds_address" {
  value = aws_db_instance.prod-db.address
}

output "rds_port" {
  value = aws_db_instance.prod-db.port
}

output "rds_resource_id" {
  value = aws_db_instance.prod-db.id
}

output "rds_username" {
  value = aws_db_instance.prod-db.username
}

output "rds_password" { #Never do this in real life!!!
  value     = random_password.db_password.result
  sensitive = true #Won't be revealed in the output
}

output "rds_all" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.prod-myssql-rds.secret_string)
  sensitive = true
}
