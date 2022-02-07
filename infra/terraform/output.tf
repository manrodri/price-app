output "asg_name" {
  value = aws_autoscaling_group.webapp_asg.name
}

output "alb_dns" {
  value = aws_alb.webapp_alb.dns_name
}

