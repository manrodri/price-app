output "ssh_command" {
  value = "ssh -i test-key.pem ubuntu@${aws_instance.nginx[0].public_ip}"
}