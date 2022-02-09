# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.small"
  subnet_id              = module.vpc.public_subnets[count.index % var.subnet_count]
  vpc_security_group_ids = [aws_security_group.webapp_inbound_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  user_data                   = file("./templates/userdata.sh")


  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-nginx${count.index + 1}" })
}
