data "aws_ssm_parameter" "docker_username" {
  name = "docker_username"
}

data "aws_ssm_parameter" "docker_password" {
  name = "docker_password"
}
