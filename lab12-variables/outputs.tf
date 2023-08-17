output "web_load_balancer_url" {
  value = aws_elb.web.dns_name
}

output "security_group_id" {
  value = aws_security_group.web.id
}
