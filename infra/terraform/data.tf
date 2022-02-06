data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-20*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

//data "aws_secretsmanager_secret_version" "creds" {
//  # Fill in the name you gave to your secret
//  secret_id = "remoteRepositorieKeys"
//}
//

