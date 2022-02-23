data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

########
# DNS
#######
//data "aws_route53_zone" "public" {
//  name         = var.demo_dns_zone
//  private_zone = false
//
//}


data "aws_key_pair" "example" {
  key_name = "test-key"

}

data "aws_subnets" "my_subnets" {

}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
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

