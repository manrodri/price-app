resource "aws_alb" "webapp_alb" {
  count = local.only_in_acg
  subnets = [for subnet in data.aws_subnets.my_subnets : subnet.id]
  security_groups = [
    aws_security_group.webapp_https_inbound_sg.id,
    aws_security_group.webapp_http_inbound_sg.id
  ]
}

resource "aws_lb_listener" "front_end-ssl" {
  count = local.only_in_acg
  load_balancer_arn = aws_alb.webapp_alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webapp_alb_tg[0].arn
  }
}




resource "aws_alb_target_group" "webapp_alb_tg" {
  count = local.only_in_acg
  name     = "${terraform.workspace}-demo-lb-target-group"
  tags     = local.common_tags
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  port     = 80
}