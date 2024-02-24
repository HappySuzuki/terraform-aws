output "web-app-instance_ip_addr" {
  value = aws_instance.web-app-instance.public_ip
}

output "db_instance_addr" {
  value = aws_db_instance.db_instance.address
}
