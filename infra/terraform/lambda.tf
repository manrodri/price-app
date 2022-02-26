resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${terraform.workspace}-lambda-price-dynamo"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*"
        ],
        "Effect": "Allow",
        "Resource": [
               "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.alerts-table.name}",
               "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.items-table.name}"

            ]
      },
      {
        "Action": [
          "ses:*"
        ],
        "Effect": "Allow",
        "Resource": [
               "*"
            ]
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "templates/lambda/deployment_package.zip"
  function_name = "alert_updater"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "alert_updater.lambda_handler"
  timeout = 30

  source_code_hash = filebase64sha256("templates/lambda/deployment_package.zip")

  runtime = "python3.7"

  environment {
    variables = {
      region = var.region,
      SENDER = var.sender,
      RECIPIENT = var.recipient,
      SUBJECT = var.subject
      smtp_username = var.smtp_username
      smtp_password = var.smtp_password

    }

  }
}

