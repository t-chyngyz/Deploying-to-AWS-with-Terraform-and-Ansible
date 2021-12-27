output "public_ip" {
  value       = aws_instance.Bastion-Host.public_ip
  description = "The public IP of the web server"
}

output "database_ip" {
  value = aws_db_instance.Demo-RDS-tf.address
  description = "RDS ip add"
}
