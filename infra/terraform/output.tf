output "instance_ip" {
  value = aws_instance.nginx[0].public_ip
}