resource "aws_s3_bucket" "example" {
}

resource "aws_iam_role" "example" {
  name = "cb-price-app-role-23e4"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.example.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "example" {
  name          = "price-app-project-3"
  build_timeout = "5"
  service_role  = aws_iam_role.example.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.example.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKER_USERNAME"
      value = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["Docker_usermane"]
      type = "SECRETS_MANAGER"
    }
    environment_variable {
      name  = "DOCKER_PASSWORD"
      value = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["Docker_password"]
      type = "SECRETS_MANAGER"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.repository_name
    }
    environment_variable {
      name  = "DB_CONNECTION_STRING"
      value = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["DB_CONNECTION_STRING"]
      type = "SECRETS_MANAGER"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.example.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.repository_url
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.repository_branch

}

resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.example.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}
