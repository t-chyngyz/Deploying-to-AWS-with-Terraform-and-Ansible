output "public_ip" {
  value       = aws_instance.Bastion-Host.public_ip
  description = "The public IP of the web server"
}
