output "web_instance_public_ip" {
  value = aws_instance.web_instance.public_ip
}

output "app_instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}

output "db_instance_public_ip" {
  value = aws_instance.db_instance.public_ip
}

output "security_group_id" {
  value = aws_security_group.instance_sg.id
}


