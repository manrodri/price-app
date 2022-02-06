resource "aws_launch_configuration" "webapp_lc" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix   = "${var.project_name}-lc-"
  image_id      = data.aws_ami.aws_linux.id
  instance_type = local.asg_instance_size

  security_groups = [
    aws_security_group.webapp_http_inbound_sg.id,
    aws_security_group.webapp_ssh_inbound_sg.id,
    aws_security_group.webapp_outbound_sg.id,
  ]

  user_data                   = file("./templates/userdata.sh")
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.asg.name
}



resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_zone_identifier   = module.vpc.public_subnets
  name                  = "${var.project_name}_asg-${terraform.workspace}"
  max_size              = local.asg_max_size
  min_size              = local.asg_min_size
  wait_for_elb_capacity = local.asg_min_size
  force_delete          = true
  launch_configuration  = aws_launch_configuration.webapp_lc.id

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}


#
# Scale Up Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "ddt_asg_scale_up-${terraform.workspace}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name                = "ddt-high-asg-cpu-${terraform.workspace}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

#
# Scale Down Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "ddt_asg_scale_down-${terraform.workspace}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name                = "ddt-low-asg-cpu-${terraform.workspace}"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
