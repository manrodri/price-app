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

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

  provisioner "file" {
    source = "templates/mongo.sh"
    destination = "/home/ubuntu/mongo.sh"
  }

  provisioner "file" {
    source = "templates/price-service.service"
    destination = "/home/ubuntu/price-service.service"
  }

  provisioner "file" {
    source = "templates/nginx.sh"
    destination = "/home/ubuntu/nginx.sh"
  }

  provisioner "file" {
    source = "templates/price-service.conf"
    destination = "/home/ubuntu/price-service.conf"
  }

  provisioner "file" {
    source = "templates/environment_file.sh"
    destination = "/home/ubuntu/environment_file.sh"
  }

   provisioner "file" {
    source = "templates/price-app.sh"
    destination = "/home/ubuntu/price-app.sh"
  }

  tags = merge(local.common_tags, { Name = "${local.common_tags.Environment}-nginx${count.index + 1}" })
}
